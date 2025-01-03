using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.EnterpriseServices;
using System.Linq;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace GooseNet
{
    

    public partial class PostWorkout : System.Web.UI.Page
    {
        private static string userAccessToken;
        private static  string userAccessTokenSecret;
        private static string workoutName;
        private static string workoutDescription;
        private static List<Dictionary<string, object>> stepsList;

        protected async void Page_Load(object sender, EventArgs e)
        {
            SetUserAccessTokenAndSecret();
            workoutName = Request.Form["workoutName"];
            workoutDescription = Request.Form["workoutDescription"];
            stepsList = GetStepsList();
            int workoutId =   MakeRequest();
        }

        private  List<Dictionary<string ,object>> GetStepsList()
        {
            List<Dictionary<string, object>> steps = new List<Dictionary<string, object>>();

            for (int i = 1; i <= int.Parse(Request.QueryString["intervals"]); i++)
            {
                Dictionary<string, object> currentStep = new Dictionary<string, object>();
                currentStep["stepOrder"] = i;
                currentStep["type"] = "WorkoutStep";
                currentStep["intensity"] = "INTERVAL";
                currentStep["decription"] = "placeHolder";
                currentStep["targetType"] = "PACE";
                string durationValueType = Request.Form[$"intervalDurationType{i}"].ToString();
                if(durationValueType == "kilometers" || durationValueType == "meters")
                {
                    currentStep["durationType"] = "DISTANCE";
                }
                else
                {
                    currentStep["durationType"] = "TIME";
                }
                double durationValue = double.Parse(Request.Form[$"intervalDurationValue{i}"]);

                switch (durationValueType)
                {
                    case "meters":
                        currentStep["durationValue"] = durationValue;
                        break;

                    case "kilometers":
                        currentStep["durationValue"] =  durationValue * 1000;
                        break;

                    case "minutes":
                        currentStep["durationValue"] = durationValue * 60;
                        break;

                    case "seconds":
                        currentStep["durationValue"] = durationValue;
                        break;
                }
                int paceMinutes = int.Parse(Request.Form[$"intervalPaceMinutes{i}"]);
                int paceSeconds = int.Parse(Request.Form[$"intervalPaceSeconds{i}"]);
                double paceInSpeed = ConvertPaceToSpeed(paceMinutes,paceSeconds);
                currentStep["targetValue"] = paceInSpeed;
                currentStep["targetValueHigh"] = paceInSpeed;
                currentStep["targetValueLow"] = paceInSpeed;
                steps.Add(currentStep);
            }


            return steps;
        }

        public double ConvertPaceToSpeed(int minutes, int seconds)
        {
            // Total time in seconds for one kilometer
            double totalSeconds = minutes * 60 + seconds;

            // Convert min/km to m/s (1000 meters in one kilometer)
            double speedMetersPerSecond = 1000 / totalSeconds;

            return speedMetersPerSecond;
        }

          int MakeRequest()
        {

            Dictionary<string,string> GarminAPICreds = GeneralMethods.GetGarminApiCredentials();
            // OAuth 1.0 credentials
            string consumerKey = GarminAPICreds["ConsumerKey"];
            string consumerSecret = GarminAPICreds["ConsumerSecret"];
            string token = userAccessToken;
            string tokenSecret = userAccessTokenSecret;

            // Define the API URL
            string url = "https://apis.garmin.com/training-api/workout";
            string url2 = "https://apis.garmin.com/training-api/schedule";
            
            // Define the JSON body content (You can modify this dictionary as needed)
            var jsonBody = new Dictionary<string, object>
        {



            { "workoutName", workoutName},
            { "description", workoutDescription },

            { "sport", "RUNNING" },

            { "steps",stepsList}

        };

          

            // Define OAuth parameters
            var oauthParams = new Dictionary<string, string>
        {
            { "oauth_consumer_key", consumerKey },
            { "oauth_token", token },
            { "oauth_nonce", Guid.NewGuid().ToString("N") }, // Unique nonce
            { "oauth_timestamp", DateTimeOffset.UtcNow.ToUnixTimeSeconds().ToString() }, // Timestamp
            { "oauth_signature_method", "HMAC-SHA1" },
            { "oauth_version", "1.0" }
        };

            // Generate the OAuth signature using HMAC-SHA1
            string signature = GenerateOAuthSignature(url, oauthParams, consumerSecret, tokenSecret);

            // Add the signature to the OAuth parameters
            oauthParams.Add("oauth_signature", signature);

            // Create the OAuth header
            string oauthHeader = "OAuth " + string.Join(", ", oauthParams.Select(p => $"{p.Key}=\"{Uri.EscapeDataString(p.Value)}\""));

            // Create an HttpClient to send the request
            var httpClient = new HttpClient();

            // Set up the POST request content
            var content = new StringContent(JsonConvert.SerializeObject(jsonBody), Encoding.UTF8, "application/json");

            // Add OAuth and other headers to the request
            httpClient.DefaultRequestHeaders.Add("Authorization", oauthHeader);
            //httpClient.DefaultRequestHeaders.Add("userId", "aff1306658024d54a856b383db3e9a2b");
            // httpClient.DefaultRequestHeaders.Add("userAccessToken", token);

            // Make the POST request
            var response =  httpClient.PostAsync(url, content).GetAwaiter().GetResult();

            // Read the response content
            var responseContent =  response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
            JObject jsonObject = JObject.Parse(responseContent);

            // Extract workoutId as an integer
            int workoutId = (int)jsonObject["workoutId"];

            // Output the response status and content
            Response.Write($"Response Status: {response.StatusCode}");
            Response.Write($"Response Body: {responseContent}");
            var jsonBodySchedule = new Dictionary<string, object>
            {
                { "workoutId", workoutId},
                {"date",Request.Form["workoutDate"].ToString() }
            };

            oauthParams = new Dictionary<string, string>
        {
            { "oauth_consumer_key", consumerKey },
            { "oauth_token", token },
            { "oauth_nonce", Guid.NewGuid().ToString("N") }, // Unique nonce
            { "oauth_timestamp", DateTimeOffset.UtcNow.ToUnixTimeSeconds().ToString() }, // Timestamp
            { "oauth_signature_method", "HMAC-SHA1" },
            { "oauth_version", "1.0" }
        };

            signature = GenerateOAuthSignature(url2, oauthParams, consumerSecret, tokenSecret);

            // Add the signature to the OAuth parameters
            oauthParams.Add("oauth_signature", signature);

            oauthHeader = "OAuth " + string.Join(", ", oauthParams.Select(p => $"{p.Key}=\"{Uri.EscapeDataString(p.Value)}\""));

            
            HttpClient httpClient2 = new HttpClient();

            var content2 = new StringContent(JsonConvert.SerializeObject(jsonBodySchedule), Encoding.UTF8, "application/json");


            httpClient2.DefaultRequestHeaders.Add("Authorization", oauthHeader);


            var response2 = httpClient2.PostAsync(url2, content2).GetAwaiter().GetResult();



            return workoutId;
        }

        // Method to generate OAuth signature (HMAC-SHA1)
        static string GenerateOAuthSignature(string url, Dictionary<string, string> oauthParams, string consumerSecret, string tokenSecret)
        {
            // Build the base string
            var baseString = BuildBaseString(url, oauthParams);

            // Create the signing key (consumer secret + "&" + token secret)
            string signingKey = Uri.EscapeDataString(consumerSecret) + "&" + Uri.EscapeDataString(tokenSecret);

            // Create HMAC-SHA1 signature
            using (var hmacsha1 = new HMACSHA1(Encoding.ASCII.GetBytes(signingKey)))
            {
                byte[] hashBytes = hmacsha1.ComputeHash(Encoding.ASCII.GetBytes(baseString));
                return Convert.ToBase64String(hashBytes);
            }
        }

        // Method to build the base string for OAuth signature
        static string BuildBaseString(string url, Dictionary<string, string> oauthParams)
        {
            // Sort parameters by name
            var sortedParams = oauthParams.OrderBy(p => p.Key)
                                          .Select(p => $"{Uri.EscapeDataString(p.Key)}={Uri.EscapeDataString(p.Value)}")
                                          .ToList();

            // Create the query string (oauth parameters)
            string baseString = string.Join("&", sortedParams);
            baseString = $"POST&{Uri.EscapeDataString(url)}&{Uri.EscapeDataString(baseString)}";

            return baseString;
        }


        private void SetUserAccessTokenAndSecret()
        {
            string conStr = @"Data Source = (LocalDB)\MSSQLLocalDB; AttachDbFilename = |DataDirectory|\GooseNetDB.mdf; Integrated Security = True";

            SqlConnection conObj = new SqlConnection(conStr);
            string cmdStr = string.Format($"SELECT * FROM GarminData WHERE username = '{Request.QueryString["athleteName"].ToString()}';");
            SqlCommand cmdObj = new SqlCommand(cmdStr, conObj);
            conObj.Open();
            SqlDataReader reader = cmdObj.ExecuteReader();

            while (reader.Read())
            {
                userAccessToken = reader["userAccessToken"].ToString();
                userAccessTokenSecret = reader["userAccessTokenSecret"].ToString();
            }

            conObj.Close();
        }
    }
}