using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class PlannedWorkout1 : System.Web.UI.Page
    {

        private HttpClient client;
        protected string workoutText;
        private const string AI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyAycAD2HR1QnpTslWedRfgicRRMjpWA5a0";
        private void ValidateAccess(PlannedWorkout plannedWorkout)
        {
            if ((Session["role"].ToString() == "coach" && Session["userName"].ToString() != plannedWorkout.CoachName) ||
                (Session["role"].ToString() == "athlete" && !plannedWorkout.AthleteNames.Contains(Session["userName"].ToString())))
            {
                PlannedWorkout wo = plannedWorkout;
                Response.Redirect("NoAccess.aspx");
            }
        }

        public  string GeneratePromptJsonRequestBody(string inputJsonString)
        {
            string prompt = "Strictly adhere to the following instructions:\n\n"
                + "1. Input: You will be provided with a JSON object describing a running workout.\n"
                + "2. Output: Generate a text representation of the workout steps, following these rules:\n"
                + "    * Display distances in meters (e.g., \"1000m\").\n"
                + "    * Display paces in minutes per kilometer (e.g., \"3:30min/km\").\n"
                + "    * Format the output with proper indentation to clearly show nested repeat steps.\n"
                + "    * Use newlines to separate each distinct step or repeated step.\n"
                + "    * Do *not* include any title or introductory text.\n" +
                "describe time in minutes and seconds if needed and not just seconds" 
                + "    * Do *not* include any cool-down or warm-up steps unless they are explicitly present in the provided JSON.\n"
                + "3. JSON Pace Conversion: The JSON provides pace values in meters per second. Convert these to minutes per kilometer using the formula: `Pace (min/km) = 1000 / (pace (m/s) * 60)`.\n"
                + "4. JSON Distance: The JSON provides distance values in meters. Use these values directly.\n"
                + "5. JSON Repeat:\n"
                + "    * If the `repeatValue` in a `WorkoutRepeatStep` is greater than 1, represent the repeated steps within parentheses, preceded by the `repeatValue` and an asterisk.\n"
                + "    * For example, `2*(` to indicate a step that repeats twice.\n"
                + "    * Properly indent the steps contained within the repeat.\n"
                + "6. JSON Output Structure: Output the results in the same order as the JSON.\n\n"
                + "Generate the output for the provided JSON below:";

            var requestBody = new JObject(
                new JProperty("contents", new JArray(
                    new JObject(
                        new JProperty("parts", new JArray(
                            new JObject(
                                new JProperty("text", prompt + "\n" + inputJsonString)
                            )
                        ))
                    )
                ))
            );

            return requestBody.ToString(Newtonsoft.Json.Formatting.None);

        }

        public string GetWorkoutText(string url, string jsonBody)
        {
            try
            {
                using (var client = new HttpClient()) // Ensure the HttpClient instance is properly scoped
                {
                    // Create the request
                    var request = new HttpRequestMessage(HttpMethod.Post, url)
                    {
                        Content = new StringContent(jsonBody, Encoding.UTF8, "application/json")
                    };

                    // Send the request synchronously
                    HttpResponseMessage response = client.SendAsync(request).GetAwaiter().GetResult();
                    response.EnsureSuccessStatusCode();

                    // Read the response content
                    string responseContent = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();

                    // Parse the JSON response
                    JObject jsonResponse = JObject.Parse(responseContent);

                    // Extract the text from the response
                    string text = jsonResponse["candidates"]?[0]?["content"]?["parts"]?[0]?["text"]?.ToString();

                    return text ?? "No text found in the response";
                }
            }
            catch (Exception ex)
            {
                return $"Error: {ex.Message}";
            }
        }

        private PlannedWorkout GetPlannedWorkout(string workoutId)
        {
            return new FirebaseService().GetData<PlannedWorkout>($"PlannedWorkouts/{workoutId}");
        }

        protected PlannedWorkout workout;
        protected void Page_Load(object sender, EventArgs e)
        {
            client = new HttpClient();
            string workoutId = Request.QueryString["workoutId"].ToString();
            string workoutJson = ((Dictionary<string,string>)new FirebaseService().GetData<Dictionary<string,string>>($"PlannedWorkoutsJSON"))[workoutId];
            workoutText = GetWorkoutText(AI_API_URL,GeneratePromptJsonRequestBody(workoutJson));
            workout = GetPlannedWorkout(workoutId);
            ValidateAccess(workout);
        }
    }
}