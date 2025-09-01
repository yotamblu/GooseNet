using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.NetworkInformation;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace GooseNet
{
    public partial class GetPlannedWorkouts : System.Web.UI.Page
    {

        
        
        private FirebaseService firebaseService;


     
        protected void Page_Load(object sender, EventArgs e)
        {
            firebaseService = new FirebaseService();

            GetWorkoutsByDate(ConvertDateFormat(Request.QueryString["date"].ToString()),
                Request.QueryString["athleteName"],
                Session["role"].ToString() == "coach"
                );
        }


        private string ConvertDateFormat(string date)
        {
            if (DateTime.TryParseExact(date, "yyyy-MM-dd", null, System.Globalization.DateTimeStyles.None, out DateTime parsedDate))
            {
                return parsedDate.ToString("MM/dd/yyyy");
            }
            else
            {
                throw new FormatException("Invalid date format. Expected yyyy-MM-dd.");
            }
        }


        private string RemoveLeadingZeros(string date)
        {
            DateTime parsedDate;
            if (DateTime.TryParse(date, out parsedDate))
            {
                return parsedDate.ToString("%M/%d/yyyy"); // %M and %d prevent zero-padding
            }
            return date; // Return original if parsing fails
        }

        public string GetWorkoutText(string id)
        {

            try
            {
                string url = "https://GooseApi.bsite.net/api/plannedWorkout/byId?id=" + id;
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


        private void GetWorkoutsByDate(string date, string targetName, bool isCoach)
        {
            int index = 1;
            bool workoutsFound = false; // Flag to check if any workouts are displayed

            foreach (KeyValuePair<string, PlannedWorkout> workout in firebaseService.GetData<Dictionary<string, PlannedWorkout>>("PlannedWorkouts"))
            {
                PlannedWorkout plannedWorkout = workout.Value;

                bool isDateMatch = RemoveLeadingZeros(date) == plannedWorkout.Date;

                if (isDateMatch)
                {
                    // Check if the workout is relevant to the current user (coach or athlete)
                    bool isRelevantToUser = false;
                    if (isCoach && plannedWorkout.CoachName == Session["userName"].ToString() && plannedWorkout.AthleteNames.Contains(Request.QueryString["athleteName"].ToString()))
                    {
                        isRelevantToUser = true;
                    }
                    else if (plannedWorkout.AthleteNames.Contains(Session["userName"].ToString()))
                    {
                        isRelevantToUser = true;
                    }

                    if (isRelevantToUser)
                    {
                        // Get the workout text description
                        string workoutText = GetWorkoutText(workout.Key);

                        Response.Write($@"
                <a href=""PlannedWorkout.aspx?workoutId={workout.Key}"" class=""block"">
                    <div class=""glass-panel rounded-xl p-6 mb-6 shadow-lg transition-all duration-300 hover:shadow-xl hover:scale-[1.01]"">
                        <div class=""flex items-center justify-between mb-4"">
                            <h2 class=""text-2xl font-bold text-blue-300"">{plannedWorkout.WorkoutName}</h2>
                            <span class=""text-lg text-gray-400"">{plannedWorkout.Date}</span>
                        </div>

                        <h4 class=""text-xl font-semibold text-white mb-4"">Workout Description:</h4>
                        <div class=""bar-container rounded-xl p-4 mb-6 bg-white bg-opacity-10 border border-white border-opacity-20"" style=""max-width: 100%; overflow-x: auto;"">
                            <div class=""w-full p-4 text-white font-light leading-relaxed"">{workoutText}</div>
                        </div>

                        <span id=""workoutID-{index}"" class=""hidden"">{workout.Key}</span>
                    </div>
                </a>");
                        workoutsFound = true;
                        index++;
                    }
                }
            }

            // If no workouts were found for this date & athlete, display a styled message
            if (!workoutsFound)
            {
                Response.Write($@"
        <span class=""text-center text-xl font-bold text-gray-300 p-8 rounded-lg glass-panel"">
            It seems that there are no planned workouts for this athlete on this date.
        </span>");
            }
        }

        // Helper function (assuming it's defined elsewhere in your C# code or GooseNetUtils)
        // private string RemoveLeadingZeros(string date) { ... }

    }
}