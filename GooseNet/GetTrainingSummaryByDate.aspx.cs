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

            if (workouts == null || !workouts.Any())
            {
                // Display a message if no workouts are found, styled with liquid glass
                return @"
                    <div class=""glass-panel rounded-xl p-8 text-center text-gray-300 font-semibold text-xl shadow-lg"">
                        No workouts found for the selected date range.
                    </div>";
            }

            foreach (Workout workout in workouts)
            {
                workoutCardsHTML += $@"
                <a href=""workout.aspx?userName={Request.QueryString["athleteName"]}&activityId={workout.WorkoutId}"" class=""block no-underline"">
                    <div class=""glass-panel rounded-xl p-6 mb-4 shadow-lg transition-all duration-300 hover:shadow-xl hover:scale-[1.01]"">
                        <div class=""flex items-center justify-between mb-2"">
                            <div class=""workout-title text-xl font-bold text-blue-300"">{workout.WokroutName}</div>
                            <div class=""workout-date text-sm text-gray-400"">{workout.WorkoutDate}</div>
                        </div>
                        <div class=""workout-details text-white text-md"">
                            <span class=""detail-label text-gray-300 font-semibold"">Distance:</span> {Math.Round(workout.WorkoutDistanceInMeters / 1000.0, 2)} km
                            <span class=""mx-2 text-gray-500"">|</span>
                            <span class=""detail-label text-gray-300 font-semibold"">Time:</span> {GooseNetUtils.ConvertSecondsToHHMMSS(workout.WorkoutDurationInSeconds)}
                        </div>
                    </div>
                </a>";
            }
            return workoutCardsHTML;
        }


        public void PrintTrainingSummary(TrainingSummary summary)
        {
            // Check for Garmin connection or no summary data
            if (summary == null || !GooseNetUtils.IsGarminConnected(Request.QueryString["athleteName"].ToString()))
            {
                Response.Write("<div class=\"glass-panel rounded-xl p-8 text-center text-red-400 font-semibold text-xl shadow-lg\">Garmin is not connected or there is no data for this athlete.</div>");
                return; // Exit the function if no data or not connected
            }

            // Check if there are no workouts in the summary
            if (summary.allWorkouts == null || summary.allWorkouts.Count == 0)
            {
                Response.Write("<div class=\"glass-panel rounded-xl p-8 text-center text-gray-300 font-semibold text-xl shadow-lg\">There are no workouts for this date range.</div>");
                return; // Exit the function if no workouts
            }

            // If data exists, generate the summary HTML
            string summaryHTML = $@"
            <div class=""summary-container container mx-auto px-4 py-4 max-w-4xl"">
                <div class=""summary-header glass-panel rounded-xl p-6 md:p-8 mb-8 shadow-lg"">
                    <h2 class=""text-2xl font-bold text-blue-300 mb-4 border-b border-white/20 pb-2"">Training Summary</h2>
                    <div class=""summary-grid grid grid-cols-1 md:grid-cols-2 gap-4 text-white"">
                        <div><strong class=""text-gray-300"">Start Date:</strong> <span class=""text-white"">{ConvertToUsFormat(Request.QueryString["startDate"])}</span></div>
                        <div><strong class=""text-gray-300"">End Date:</strong> <span class=""text-white"">{ConvertToUsFormat(Request.QueryString["endDate"])}</span></div>
                        <div><strong class=""text-gray-300"">Total Workouts:</strong> <span class=""text-white"">{summary.allWorkouts.Count}</span></div>
                        <div><strong class=""text-gray-300"">Total Distance:</strong> <span class=""text-white"">{Math.Round(summary.distanceInKilometers, 2)} km</span></div>
                        <div><strong class=""text-gray-300"">Avg Daily Distance:</strong> <span class=""text-white"">{Math.Round(summary.averageDailyInKilometers, 2)} km</span></div>
                        <div><strong class=""text-gray-300"">Total Time:</strong> <span class=""text-white"">{GooseNetUtils.ConvertSecondsToHHMMSS((int)summary.timeInSeconds)}</span></div>
                        <div><strong class=""text-gray-300"">Avg Daily Time:</strong> <span class=""text-white"">{GooseNetUtils.ConvertSecondsToHHMMSS((int)summary.averageDailyInSeconds)}</span></div>
                    </div>
                </div>

                <div class=""workouts-section space-y-4"">
                    {GetWorkoutCards(summary)}
                </div>
            </div>";

            Response.Write(summaryHTML);
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