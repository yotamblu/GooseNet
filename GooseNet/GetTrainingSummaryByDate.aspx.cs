using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class GetTrainingSummaryByDate : System.Web.UI.Page
    {

        protected TrainingSummary summary;

        public static string ConvertToUsFormat(string yyyyMMdd)
        {
            if (DateTime.TryParseExact(yyyyMMdd.Trim(), "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime parsedDate))
            {
                return parsedDate.ToString("MM/dd/yyyy");
            }
            else
            {
                throw new FormatException("Input date must be in yyyy-MM-dd format.");
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userName"] == null || !GooseNetUtils.IsCoachingOrIsUser(Session["userName"].ToString(), Request.QueryString["athleteName"]))
            {
                Response.Redirect("NoAccess.aspx");
            }
            FirebaseService firebaseService = new FirebaseService();
            string userAccessToken = GooseNetUtils.GetUserAccessTokenByUserName(Request.QueryString["athleteName"]);
            Dictionary<string,Workout> workouts = firebaseService.GetData<Dictionary<string,Workout>>("Activities/" + userAccessToken);
            string startDate = ConvertToUsFormat(Request.QueryString["startDate"].ToString());
            string endDate = ConvertToUsFormat(Request.QueryString["endDate"].ToString());
            try
            {
                summary = BuildTrainingSummary(startDate, endDate, workouts);
                PrintTrainingSummary(summary);
            }catch(Exception ex)
            {
                if(ex.Message == "endDate must be after or equal to startDate.")
                {
                    Response.Write("<div class=\"placeholder\">End Date must be afer or equal to Start Date</div>");
                }
            }
       
        }



        public string GetWorkoutCards(TrainingSummary summary)
        {
            List<Workout> workouts = summary.allWorkouts;
            string workoutCardsHTML = "";


            foreach(Workout workout in workouts)
            {
                workoutCardsHTML += $"<a href=\"workout.aspx?userName={Request.QueryString["athleteName"]}&activityId={workout.WorkoutId}\"> <div class=\"workouts-section\">\r\n" +
                    $"      <div class=\"workout-card\">\r\n" +
                    $"        <div class=\"workout-title\">{workout.WokroutName}</div>\r\n" +
                    $"        <div class=\"workout-date\">{workout.WorkoutDate}</div>\r\n" +
                    $"        <div class=\"workout-details\"><span class=\"detail-label\">Distance:</span> {Math.Round(workout.WorkoutDistanceInMeters / 1000,2)} km |" +
                    $" <span class=\"detail-label\">Time:{GooseNetUtils.ConvertSecondsToHHMMSS(workout.WorkoutDurationInSeconds)}</span> </div>\r\n" +
                    $"      </div>";
            }
            return workoutCardsHTML;
        }

        

        public void PrintTrainingSummary(TrainingSummary summary)
        {
            if (summary == null || !GooseNetUtils.IsGarminConnected(Request.QueryString["athleteName"].ToString()))
                Response.Write("<div class=\"placeholder\">There is no data for this time range!</div>");
             if(summary.allWorkouts.Count == 0) {
                Response.Write("<div class=\"placeholder\">There Are no Workouts for this Date Range</div>");

            }
            else
            {
                string summaryHTML = "<div class=\"summary-container\">\r\n" +
                "    <div class=\"summary-header\">\r\n" +
                "      <h2>Training Summary</h2>\r\n " +
                $"     <div class=\"summary-grid\">\r\n" +
                $"        <div><strong>Start Date:{ConvertToUsFormat(Request.QueryString["startDate"])}</strong> </div>\r\n" +
                $"        <div><strong>End Date:{ConvertToUsFormat(Request.QueryString["endDate"])}</strong> </div>\r\n" +
                $"        <div><strong>Total Workouts:</strong> {summary.allWorkouts.Count}</div>\r\n " +
                $"       <div><strong>Total Distance:</strong> {Math.Round(summary.distanceInKilometers, 2)} km</div>\r\n" +
                $"        <div><strong>Avg Daily Distance:</strong> {Math.Round(summary.averageDailyInKilometers, 2)} km</div>\r\n" +
                $"        <div><strong>Total Time:</strong> {GooseNetUtils.ConvertSecondsToHHMMSS((int)summary.timeInSeconds)}</div>\r\n " +
                $"       <div><strong>Avg Daily Time:</strong> {GooseNetUtils.ConvertSecondsToHHMMSS((int)summary.averageDailyInSeconds)}</div>\r\n" +
                "      </div>\r\n    </div>\r\n\r\n    <div class=\"workouts-section\">" +
                $"{GetWorkoutCards(summary)}\r\n" +
                "</div></div><div>";

                Response.Write(summaryHTML);
            }
            
        }


        public TrainingSummary BuildTrainingSummary(string startDate, string endDate, Dictionary<string, Workout> workouts)
        {
            if (!DateTime.TryParseExact(startDate.Trim(), "M/d/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime start))
                throw new ArgumentException("Invalid startDate format. Expected M/d/yyyy");
            if (!DateTime.TryParseExact(endDate.Trim(), "M/d/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime end))
                throw new ArgumentException("Invalid endDate format. Expected M/d/yyyy");
            if (end < start)
                throw new ArgumentException("endDate must be after or equal to startDate.");

            // Cache parsed dates for each unique WorkoutDate string
            var dateCache = new Dictionary<string, DateTime>(workouts.Count);

            var filteredWorkouts = new List<Workout>(workouts.Count);
            double totalDistanceKm = 0;
            double totalTimeSec = 0;

            foreach (var workout in workouts.Values)
            {
                if (string.IsNullOrWhiteSpace(workout.WorkoutDate))
                    continue;

                if (!dateCache.TryGetValue(workout.WorkoutDate, out DateTime parsedDate))
                {
                    if (!DateTime.TryParseExact(workout.WorkoutDate.Trim(), "M/d/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out parsedDate))
                        continue; // skip invalid dates

                    dateCache[workout.WorkoutDate] = parsedDate;
                }

                if (parsedDate < start || parsedDate > end)
                    continue;

                filteredWorkouts.Add(workout);
                totalDistanceKm += workout.WorkoutDistanceInMeters / 1000.0;
                totalTimeSec += workout.WorkoutDurationInSeconds;
            }

            // Sort descending by date (newest first) using cached parsed dates
            filteredWorkouts.Sort((a, b) => dateCache[b.WorkoutDate].CompareTo(dateCache[a.WorkoutDate]));

            int totalDays = (end - start).Days + 1;

            return new TrainingSummary
            {
                startDate = start.ToShortDateString(),
                endDate = end.ToShortDateString(),
                distanceInKilometers = totalDistanceKm,
                averageDailyInKilometers = totalDays > 0 ? totalDistanceKm / totalDays : 0,
                timeInSeconds = totalTimeSec,
                averageDailyInSeconds = totalDays > 0 ? totalTimeSec / totalDays : 0,
                allWorkouts = filteredWorkouts
            };
        }
    }
}