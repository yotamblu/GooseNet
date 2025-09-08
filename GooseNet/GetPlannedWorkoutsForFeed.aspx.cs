using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class GetPlannedWorkoutsForFeed : System.Web.UI.Page
    {
        bool isFlock;
        string targetParam;
        FirebaseService firebaseService;
        string coachName;
        protected int requestedIndex;
        protected void Page_Load(object sender, EventArgs e)
        {
            firebaseService = new FirebaseService();
            isFlock = Request.QueryString["flockName"] != null;
            coachName = Request.QueryString["coachName"];
            targetParam = isFlock ? $"flockName={Request.QueryString["flockName"]}" : $"athleteName={Request.QueryString["athleteName"]}";
            requestedIndex = int.Parse(Request.QueryString["index"]);
            GooseNetUtils.GetCoachsPlannedWorkouts(coachName);
            if (Session["userName"] == null || Session["userName"].ToString() != coachName)
            {
                Response.Write("Session Timeout!");
            }
        }


        protected string GetWorkoutSummaryHTML(int index)
        {
            Dictionary<string, PlannedWorkout> keyValuePairs = GooseNetUtils.GetCoachsPlannedWorkouts(coachName);
            int currentIndex = 0;
            string finalHtml = string.Empty;
            foreach (KeyValuePair<string, PlannedWorkout> kvp in keyValuePairs)
            {
                if (currentIndex >= 4 * index + 4) break;
                if (currentIndex >= 4 * index )
                {
                    string workoutText = GooseNetUtils.GetWorkoutText(kvp.Key);
                    PlannedWorkout plannedWorkout = kvp.Value;
                    finalHtml += $@"
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

        <span id=""workoutID-{kvp.Key}"" class=""hidden"">{kvp.Key}</span>

        <!-- Action Button -->
        <div class=""flex justify-end items-center mt-4 pt-4 border-t border-white/20"">
            <a href=""AddComplexWorkout{(isFlock ? "Tolock" : "")}.aspx?workoutId={kvp.Key}&{targetParam}"" class=""text-white font-semibold py-2 px-6 rounded-lg transition-all duration-300 bg-blue-500/40 hover:bg-blue-500/60"">EDIT & SEND</a>
        </div>
    </div>
</div>";
                }
                currentIndex++;

            }

            return finalHtml;
        }

        
    }
}