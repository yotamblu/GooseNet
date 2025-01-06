using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace GooseNet
{
    public partial class GetOAuthTokenandSecret : System.Web.UI.Page
    {
        private  string ConsumerKey;
        private  string ConsumerSecret;
        private  string RequestTokenUrl = "https://connectapi.garmin.com/oauth-service/oauth/request_token";

        public void CheckForAccess()
        {
            if (Session["userName"] == null)
            {
                Response.Redirect("NoAccess.aspx");
            }


        }
        private void SetGarminAPICreds()
        {
            Dictionary<string,string> creds = GooseNetUtils.GetGarminAPICredentials();
            

            ConsumerKey = creds["ConsumerKey"];
            ConsumerSecret = creds["ConsumerSecret"];
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            SetGarminAPICreds();


            CheckForAccess();


            if (!IsPostBack)
            {
                try
                {
                 
                     string baseUrl = Request.Url.Scheme + "://" + Request.Url.Authority +
                     Request.ApplicationPath.TrimEnd('/') + "/";
                    string callbackUrl = baseUrl + "callback.aspx";
                    string response = GetRequestToken();
                    Response.Write($"<h2>OAuth Token Response:</h2><p>{response}</p>");
                    string redirectParams = $"?{response}&oauth_callback={UrlEncode(callbackUrl)}";



                    Response.Redirect("https://connect.garmin.com/oauthConfirm" + redirectParams);
                }
                catch (Exception ex)
                {
                    Response.Write($"<h2>Error:</h2><p>{ex.Message}</p>");
                }
            }

          
        }

        private string GetRequestToken()
        {
            // Step 1: Generate OAuth Parameters
            string nonce = GenerateNonce();
            string timestamp = GenerateTimestamp();

            var oauthParams = new Dictionary<string, string>
            {
                { "oauth_consumer_key", ConsumerKey },
                { "oauth_nonce", nonce },
                { "oauth_signature_method", "HMAC-SHA1" },
                { "oauth_timestamp", timestamp },
                { "oauth_version", "1.0" }
            };

            // Step 2: Generate OAuth Signature
            string signature = GenerateOAuthSignature("POST", RequestTokenUrl,oauthParams,ConsumerSecret,"");
            oauthParams.Add("oauth_signature", signature);

            // Step 3: Build Authorization Header
            string authHeader = "OAuth " + string.Join(", ",
                oauthParams.Select(p => $"{p.Key}=\"{p.Value}\""));

            // Step 4: Send HTTP POST Request
            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Add("Authorization", authHeader);
                HttpResponseMessage response = client.PostAsync(RequestTokenUrl, null).Result;
                Session["response"] = response.Content.ReadAsStringAsync().Result;
                 return response.Content.ReadAsStringAsync().Result;
            }
        }

        // Generate Nonce (random unique string)
        private string GenerateNonce()
        {
            return new Random().Next(123400, 9999999).ToString();
        }

        // Generate Timestamp (current Unix time)
        private string GenerateTimestamp()
        {
            return ((int)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1))).TotalSeconds).ToString();
        }

        // Generate OAuth Signature
        public static string GenerateOAuthSignature(
       string httpMethod,
       string baseUrl,
       Dictionary<string, string> oauthParams,
       string consumerSecret,
       string tokenSecret)
        {
            // Normalize parameters (alphabetical order and URL-encode)
            var normalizedParams = string.Join("&", oauthParams
                .OrderBy(kvp => kvp.Key) // Alphabetical order
                .Select(kvp => $"{(kvp.Key)}={(kvp.Value)}"));

            // Construct the signature base string
            string signatureBaseString = $"{httpMethod.ToUpper()}&{UrlEncode(baseUrl)}&{UrlEncode(normalizedParams)}";

            // Create the signing key
            string signingKey = $"{(consumerSecret)}&{(tokenSecret)}";

            // Generate the HMAC-SHA1 signature
            string oauthSignature;
            using (var hmac = new HMACSHA1(Encoding.UTF8.GetBytes(signingKey)))
            {
                byte[] hashBytes = hmac.ComputeHash(Encoding.UTF8.GetBytes(signatureBaseString));
                oauthSignature = Convert.ToBase64String(hashBytes);
            }

            return UrlEncode(oauthSignature);
        }

        static string UrlEncode(string value)
        {
            return HttpUtility.UrlEncode(value)
                .Replace("+", "%20")
                .Replace("*", "%2A")
                .Replace("%7E", "~")
                .Replace("%3a", "%3A")
                .Replace("%2f", "%2F")
                .Replace("%3d", "%3D");
        }

    }
}
