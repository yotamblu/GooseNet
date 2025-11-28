using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class PlannedStrengthWorkout : System.Web.UI.Page
    {

        FirebaseService firebaseService;
        StrengthWorkout workout;
        protected bool hasSubmitted = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userName"] == null || Request.QueryString["workoutId"] == null)
            {
                Response.Redirect("NoAccess.aspx");
            }
            firebaseService = new FirebaseService();
            workout = firebaseService.GetData<StrengthWorkout>($"PlannedStrengthWorkouts/{Request.QueryString["workoutId"].ToString()}");
            string userName = Session["userName"].ToString();
            if(workout == null || (!workout.AthleteNames.Contains(userName) && workout.CoachName != userName)){
                Response.Redirect("NoAccess.aspx");
            }




        }


        public void GetReviews()
        {
            if (Session["role"].ToString() == "coach")
            {
                if (workout.WorkoutReviews != null)
                {
                    foreach (KeyValuePair<string, StrengthWorkoutReview> reviewKVP in workout.WorkoutReviews)
                    {
                        StrengthWorkoutReview review = reviewKVP.Value;

                        Response.Write($@"

   

    <!-- Review Content Panel -->
    <div class=""glass-panel p-6 rounded-xl border border-white/30 shadow-xl space-y-6""> 

        <!-- Athlete Header -->
        <div class=""flex items-center gap-4 pb-4 border-b border-white/20"">
            <img src=""{GooseNetUtils.GetUserPicStringByUserName(review.AthleteName)}"" 
                 onerror=""this.onerror=null; this.src='https://placehold.co/64x64/3b82f6/ffffff?text=U'"" 
                 alt=""Athlete Profile Picture"" 
                 class=""w-16 h-16 rounded-full object-cover border-2 border-cyan-400 shadow-md"">
            
            <div>
                <p class=""text-xl font-semibold text-white"">{review.AthleteName}</p>
            </div>
        </div>
        
        <!-- Submission Controls -->
        <div class=""flex flex-col items-center w-full space-y-6"">

            <!-- Difficulty Slider -->
            <div class=""w-full"">
                <label for=""difficulty"" class=""text-lg font-medium block mb-2"">
                    Workout Difficulty: 
                    <span id=""diffValue"" class=""font-bold text-xl text-cyan-300"">{review.DifficultyLevel}</span>/10
                </label>

                <input type=""range"" 
                       id=""difficulty"" 
                       min=""1"" 
                       max=""10"" 
                       value=""{review.DifficultyLevel}"" 
                       class=""w-full""
                       oninput=""document.getElementById('diffValue').textContent = this.value"" />
            </div>

            <!-- Review Text -->
            <div class=""w-full"">
                <label for=""athleteReview"" class=""text-lg font-medium block mb-2"">Notes & Feedback:</label>
                <textarea readonly id=""athleteReview"" rows=""5"" 
                          placeholder=""How did the workout feel? Any observations?"" 
                          class=""w-full p-4 rounded-xl border border-white/30 bg-white/10 
                                 text-white placeholder-white/50 focus:outline-none 
                                 focus:ring-2 focus:ring-cyan-400 transition-all duration-200 
                                 disabled:bg-white/5 disabled:text-white/60 disabled:cursor-not-allowed 
                                 resize-none"">{review.ReviewContent}</textarea>
            </div>

        </div>
    </div>
");
                    }
                }
                else
                {
                    Response.Write(@"
<div class=""glass-panel p-6 md:p-8 rounded-3xl shadow-2xl text-center"">
    <svg class=""w-12 h-12 mx-auto mb-4 text-purple-300/80"" fill=""none"" stroke=""currentColor"" viewBox=""0 0 24 24"" xmlns=""http://www.w3.org/2000/svg"">
        <path stroke-linecap=""round"" stroke-linejoin=""round"" stroke-width=""2"" d=""M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.405L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9""></path>
    </svg>

    <h3 class=""text-xl font-semibold text-white mb-2"">Review Pending</h3>
    <p class=""text-base text-white/70"">
        No athlete has submitted a review for this workout yet. Check back later!
    </p>
</div>");
                }
            }
            else
            {
                string userName = Session["userName"].ToString();
                 hasSubmitted = workout.WorkoutReviews != null && workout.WorkoutReviews.ContainsKey(Session["userName"].ToString());
                StrengthWorkoutReview review = null;
                if (hasSubmitted)
                {
                    review = workout.WorkoutReviews[userName];
                }
                Response.Write($@"
    
  

    <!-- C: Review Content Panel - The submission form itself is in a separate liquid glass layer -->
    <div class=""glass-panel p-6 rounded-xl border border-white/30 shadow-xl space-y-6""> 

        <!-- Athlete Profile Header -->
        <div class=""flex items-center gap-4 pb-4 border-b border-white/20"">
            <!-- Profile Picture: Using a placeholder image URL for the profile pic -->
            <img src=""{GooseNetUtils.GetUserPicStringByUserName(userName)}"" 
                 onerror=""this.onerror=null; this.src='https://placehold.co/64x64/3b82f6/ffffff?text=U'"" 
                 alt=""Athlete Profile Picture"" 
                 class=""w-16 h-16 rounded-full object-cover border-2 border-cyan-400 shadow-md"">
            
            <div>
                <!-- Display Athlete Name -->
                <p class=""text-xl font-semibold text-white"">{userName}</p>
            </div>
        </div>
        
        <!-- Submission Controls -->
        <div class=""flex flex-col items-center w-full space-y-6"">

            <!-- Difficulty Slider -->
            <div class=""w-full"">
                <label for=""difficulty"" class=""text-lg font-medium block mb-2"">Workout Difficulty: <span id=""diffValue"" class=""font-bold text-xl text-cyan-300"">{(review == null ? 1 : review.DifficultyLevel)}</span>/10</label>
                <input type=""range"" id=""difficulty"" min=""1"" max=""10"" value=""{(review == null ? 1 : review.DifficultyLevel)}"" 
                        class=""w-full""
                        oninput=""document.getElementById('diffValue').textContent = this.value"" />
            </div>

            <!-- Review Text Area -->
            <div class=""w-full"">
                <label for=""athleteReview"" class=""text-lg font-medium block mb-2"">Notes & Feedback:</label>
                <textarea id=""athleteReview"" rows=""5"" placeholder=""How did the workout feel? Any modifications or observations?"" 
                        class=""w-full p-4 rounded-xl border border-white/30 bg-white/10 text-white placeholder-white/50 focus:outline-none focus:ring-2 focus:ring-cyan-400 transition-all duration-200 disabled:bg-white/5 disabled:text-white/60 disabled:cursor-not-allowed resize-none"">
        {(review == null ? "" : review.ReviewContent)}</textarea>
            </div>
            
            <!-- Submit/Edit Button -->
            <button id=""submitBtn"" type=""button"" onclick=""toggleLock()""
                    class=""submit-button bg-blue-600 w-full md:w-auto px-10 py-3 rounded-xl text-xl font-bold text-white shadow-lg focus:outline-none focus:ring-4 focus:ring-blue-400/50 hover:bg-blue-700 disabled:bg-gray-500 disabled:cursor-not-allowed"">
                Submit Workout
            </button>
        </div>
</div>
");
            }
        }


        protected string GetCoachName() => workout.CoachName;
        protected string GetWorkoutDescription() => workout.WorkoutDescription;
        protected string GetWorkoutName() => workout.WorkoutName;
        protected string GetWorkoutStructure()
        {
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

           
            string itemClasses = "bg-white/10 p-3 rounded-xl border border-white/20 flex justify-between items-center transition-all duration-300 hover:bg-white/20 hover:scale-[1.01] hover:shadow-2xl cursor-pointer";

            if (workout != null && workout.WorkoutDrills != null)
            {
                foreach (StrengthWorkoutDrill drill in workout.WorkoutDrills)
                {
                   
                    string drillHtml = $@"
            <div  style='margin-top:1vh'  class='{itemClasses}'>
                <div class='text-lg font-medium text-cyan-300'>{drill.DrillSets}x{drill.DrillReps}</div>
                <div class='text-base font-semibold text-white/90 text-right'>{drill.DrillName}</div>
            </div>";
                    sb.Append(drillHtml);
                }
            }
            else
            {
                sb.Append("<p class='text-white/60 p-3'>No strength drills are currently planned for this workout.</p>");
            }

            return sb.ToString();


        }
    }
}