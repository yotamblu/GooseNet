using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;
using System.Net;
using System.IO;
using System.Web.UI;
using System.Security;
using System.Data.SqlClient;

namespace GooseNet
{
    public partial class callback : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Get OAuth Verifier from query string
            string oauthVerifier = Request.QueryString["oauth_verifier"];
            if (string.IsNullOrEmpty(oauthVerifier))
            {
                Response.Write("OAuth Verifier is missing.");
                return;
            }

            // OAuth credentials
            string consumerKey = "f76c8658-fa7f-4d8f-ae3c-22ba55926aa6";
            string token = Request.QueryString["oauth_token"];
            string consumerSecret = "1QXS9ZEBXFdV7Hq9WeEoYE41ejrFQfu7lkt";
            string sess = Session["response"].ToString();
            string tokenSecret = sess.Substring(sess.LastIndexOf('=') + 1,sess.Length - (sess.LastIndexOf('=') + 1));

            // Generate OAuth parameters
            long timestamp = GenerateTimestamp();
            string nonce = GenerateNonce();

            // Prepare parameters for the signature
            var parameters = new Dictionary<string, string>
            {
                { "oauth_verifier", oauthVerifier },
                { "oauth_version", "1.0" },
                { "oauth_consumer_key", consumerKey },
                { "oauth_token", token },
                { "oauth_timestamp", timestamp.ToString() },
                { "oauth_nonce", nonce },
                { "oauth_signature_method", "HMAC-SHA1" }
            };

            // Generate the OAuth signature
            string baseUrl = "https://connectapi.garmin.com/oauth-service/oauth/access_token";
            string signature = GenerateSignature(baseUrl, parameters, consumerSecret, tokenSecret);

            // Add signature to parameters
            parameters.Add("oauth_signature", signature);

            // Make the POST request
            string response = MakePostRequest(baseUrl, parameters);
            Response.Write("Response: " + response);
            string userAccessToken = response.Substring(response.IndexOf("=") + 1, response.IndexOf('&') - response.IndexOf('=') - 1);
            string userAccessTokenSecret = response.Substring(response.LastIndexOf("=") + 1, response.Length - (response.LastIndexOf("=") + 1));
           ConnectUser(userAccessToken,userAccessTokenSecret);
        }
        public void ConnectUser(string userAccessToken , string userAccessTokenSecret) {
            if (Session["userName"] != null)
            {
                string conStr = @"Data Source = (LocalDB)\MSSQLLocalDB; AttachDbFilename = |DataDirectory|\GooseNetDB.mdf; Integrated Security = True";

                SqlConnection conObj = new SqlConnection(conStr);
                string cmdStr = string.Format($"INSERT INTO GarminData VALUES('{Session["userName"].ToString()}','{userAccessToken}','{userAccessTokenSecret}')");
                SqlCommand cmdObj = new SqlCommand(cmdStr, conObj);
                conObj.Open();
                cmdObj.ExecuteNonQuery();

                conObj.Close();
            }    
        
        }


        // Method to generate nonce
        private string GenerateNonce()
        {
            using (var rng = new RNGCryptoServiceProvider())
            {
                byte[] bytes = new byte[16];
                rng.GetBytes(bytes);
                return BitConverter.ToString(bytes).Replace("-", string.Empty);
            }
        }

        // Method to generate timestamp
        private long GenerateTimestamp()
        {
            return DateTimeOffset.Now.ToUnixTimeSeconds();
        }

        // Method to generate the OAuth signature
        private string GenerateSignature(string url, Dictionary<string, string> parameters, string consumerSecret, string tokenSecret)
        {
            // Sort parameters alphabetically by key
            var sortedParams = new SortedDictionary<string, string>(parameters);

            // Create the base string
            StringBuilder baseString = new StringBuilder();
            baseString.Append("POST&");
            baseString.Append(Uri.EscapeDataString(url));
            baseString.Append("&");

            StringBuilder parameterString = new StringBuilder();
            foreach (var param in sortedParams)
            {
                if (parameterString.Length > 0)
                    parameterString.Append("&");
                parameterString.Append(Uri.EscapeDataString(param.Key) + "=" + Uri.EscapeDataString(param.Value));
            }

            baseString.Append(Uri.EscapeDataString(parameterString.ToString()));

            // Create the signing key
            string signingKey = Uri.EscapeDataString(consumerSecret) + "&" + Uri.EscapeDataString(tokenSecret);

            // Generate HMAC-SHA1 signature
            using (HMACSHA1 hmacsha1 = new HMACSHA1(Encoding.ASCII.GetBytes(signingKey)))
            {
                byte[] hashBytes = hmacsha1.ComputeHash(Encoding.ASCII.GetBytes(baseString.ToString()));
                return Convert.ToBase64String(hashBytes);
            }
        }

        // Method to make the POST request
        private string MakePostRequest(string url, Dictionary<string, string> parameters)
        {
            try
            {
                // Prepare the POST data
                StringBuilder postData = new StringBuilder();
                foreach (var param in parameters)
                {
                    if (postData.Length > 0)
                        postData.Append("&");
                    postData.Append(Uri.EscapeDataString(param.Key) + "=" + Uri.EscapeDataString(param.Value));
                }

                // Create the web request
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                request.Method = "POST";
                request.ContentType = "application/x-www-form-urlencoded";
                request.ContentLength = postData.Length;

                using (StreamWriter writer = new StreamWriter(request.GetRequestStream()))
                {
                    writer.Write(postData.ToString());
                }

                // Get the response
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                {
                    return reader.ReadToEnd();
                }
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
        }
    }
}