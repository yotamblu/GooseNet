using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class SearchForPlannedWorkout : System.Web.UI.Page
    {
        string coachName;
        string searchQuery;
        protected void Page_Load(object sender, EventArgs e)
        {
            coachName = Request.QueryString["coachName"];
            searchQuery = Request.QueryString["q"];
            if (Session["userName"] == null || Session["userName"].ToString() != coachName)
            {
                Response.Redirect("NoAccess.aspx");
            }
            Dictionary<string, PlannedWorkout> allWorkoutsFromCoach = GooseNetUtils.GetCoachsPlannedWorkouts(coachName);
            List<string> relevantWorkouts = FindRelevantWorkouts(allWorkoutsFromCoach, searchQuery);
            foreach(string workoutId  in relevantWorkouts)
            {
                string workoutText = GooseNetUtils.GetWorkoutText(workoutId);
                PlannedWorkout plannedWorkout = allWorkoutsFromCoach[workoutId];
                Response.Write($@"
<div class=""block"">
    <div class=""glass-panel rounded-xl p-6 mb-6 shadow-lg transition-all duration-300 hover:shadow-xl hover:scale-[1.01]"">
        <div class=""flex items-center justify-between mb-4"">
            <h2 class=""text-2xl font-bold text-blue-300"">{plannedWorkout.WorkoutName}</h2>
            <span class=""text-lg text-gray-400"">{plannedWorkout.Date}</span>
        </div>

        <h4 class=""text-xl font-semibold text-white mb-4"">Workout Description:</h4>
        <div class=""bar-container rounded-xl p-4 mb-6 bg-white bg-opacity-10 border border-white border-opacity-20"" style=""max-width: 100%; overflow-x: auto;"">
            <div class=""w-full p-4 text-white font-light leading-relaxed"">{workoutText}</div>
        </div>

        <span id=""workoutID-{workoutId}"" class=""hidden"">{workoutId}</span>

        <!-- Action Button -->
        <div class=""flex justify-end items-center mt-4 pt-4 border-t border-white/20"">
            <a href=""EditAndSendWorkout.aspx?id={workoutId}"" class=""text-white font-semibold py-2 px-6 rounded-lg transition-all duration-300 bg-blue-500/40 hover:bg-blue-500/60"">EDIT & SEND</a>
        </div>
    </div>
</div>");
            }
        }
       

        

        public static List<string> FindRelevantWorkouts(Dictionary<string, PlannedWorkout> workouts,string searchQuery)
        {
            if (string.IsNullOrWhiteSpace(searchQuery))
                return new List<string>();

            string query = searchQuery.Trim().ToLower();

            var results = workouts
                .Where(w =>
                    
                    (!string.IsNullOrEmpty(w.Value.WorkoutName) && w.Value.WorkoutName.ToLower().Replace(" ", "").Contains(query)) ||
                    (!string.IsNullOrEmpty(w.Value.WorkoutName) && w.Value.WorkoutName.ToLower().Contains(query)))
                .Select(w => w.Key)
                .ToList();

            return results;
        }
    }
 }