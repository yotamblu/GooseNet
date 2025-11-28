using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics.Eventing.Reader;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class AddStrengthWorkout : System.Web.UI.Page
    {
        public StrengthWorkout strengthWorkout;
        public bool isFromLibrary;
        protected string GetTargetParam()
        {
            bool isFlock = Request.QueryString["flockName"] != null;
            if (isFlock)
            {
                return $"?flockName={Request.QueryString["flockName"]}";
            }
            return $"?athleteName={Request.QueryString["athleteName"]}";
        }

        protected string GetDrillsHtml()
        {
            string drillsHtml = "";
            foreach (StrengthWorkoutDrill drill in strengthWorkout.WorkoutDrills)
            {
                drillsHtml += "<div class=\"drill\">\r\n" +
                    $"            <label>Drill Name</label>\r\n" +
                    $"            <input class=\"drill-name\" value=\"{drill.DrillName}\" placeholder=\"Bench Press, Squats, etc\" fdprocessedid=\"lkoyc\">\r\n\r\n" +
                    $"            <label>Number of Sets</label>\r\n" +
                    $"            <input class=\"drill-sets\" value=\"{drill.DrillSets}\" type=\"number\" min=\"1\" placeholder=\"3\" fdprocessedid=\"p0j47k\">\r\n\r\n" +
                    $"            <label>Reps Per Set</label>\r\n" +
                    $"            <input class=\"drill-reps\" type=\"number\" value=\"{drill.DrillReps}\" min=\"1\" placeholder=\"10\" fdprocessedid=\"y321el\">\r\n" +
                    $"        </div>";
            }

            return drillsHtml;
        }



        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userName"] == null)
            {
                Response.Redirect("NoAccess.aspx");
            }
            string requestedWorkoutId = Request.QueryString["workoutId"] != null ? Request.QueryString["workoutId"].ToString() : null;
            isFromLibrary = requestedWorkoutId != null;
            if (isFromLibrary)
            {
                strengthWorkout = new FirebaseService().GetData<StrengthWorkout>($"PlannedStrengthWorkouts/{requestedWorkoutId}");
            }


        }
    }
}