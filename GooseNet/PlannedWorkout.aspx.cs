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
        private const string GOOSE_API_URL = "https://gooseapi.bsite.net/api/plannedWorkout/byId";
        private void ValidateAccess(PlannedWorkout plannedWorkout)
        {
            if ((Session["role"].ToString() == "coach" && Session["userName"].ToString() != plannedWorkout.CoachName) ||
                (Session["role"].ToString() == "athlete" && !plannedWorkout.AthleteNames.Contains(Session["userName"].ToString())))
            {
                PlannedWorkout wo = plannedWorkout;
                Response.Redirect("NoAccess.aspx");
            }
        }

        

        public string GetWorkoutText(string url)
        {
            
            try
            {
                url += "?id=" + Request.QueryString["workoutId"];
                using (var client = new HttpClient()) // Ensure the HttpClient instance is properly scoped
                {
                    // Create the request
                    var request = new HttpRequestMessage(HttpMethod.Get, url);
                   

                    // Send the request synchronously
                    HttpResponseMessage response = client.SendAsync(request).GetAwaiter().GetResult();
                    response.EnsureSuccessStatusCode();

                    // Read the response content
                    string responseContent = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();

                    // Parse the JSON response
                    JObject jsonResponse = JObject.Parse(responseContent);

                    // Extract the text from the response
                    string text = jsonResponse["plannedWorkoutJson"]?.ToString();

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
            workoutText = GetWorkoutText(GOOSE_API_URL);
            workout = GetPlannedWorkout(workoutId);
            ValidateAccess(workout);
        }
    }
}