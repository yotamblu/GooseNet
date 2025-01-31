using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class GetWorkoutCoordinates : System.Web.UI.Page
    {
        FirebaseService firebaseService;
        List<Workout> workouts;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!GooseNetUtils.IsConnectedToUser(Session, Session["requestedAthlete"].ToString()))
            {
                Response.Redirect("NoAccess.aspx");
            }

            firebaseService = new FirebaseService();

            workouts = GooseNetUtils.GetRelevantWorkouts(Request.QueryString["date"],Session);

            int index = int.Parse(Request.QueryString["index"]);

            Response.Write(workouts[index - 1].WorkoutCoordsJsonStr);
        }
    }
}