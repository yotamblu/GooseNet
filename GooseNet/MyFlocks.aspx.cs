using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class MyFlocks : System.Web.UI.Page
    {
        private FirebaseService firebaseService;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["role"] == null || Session["role"].ToString() != "coach")
            {
                Response.Redirect("noAccess.aspx");
            }
            firebaseService = new FirebaseService();
        }


        protected void ShowFlockCards()
        {
            Dictionary<string, Flock> coachFlocks = firebaseService.GetData<Dictionary<string, Flock>>($"Flocks/{Session["userName"]}");
            foreach (KeyValuePair<string,Flock> flock in coachFlocks)
            {
                Response.Write(" <fieldset>\r\n " +
                 $"<span class=\"athleteName\">{flock.Key}</span><br/>\r\n        " +
                $"<button class=\"workoutBtns\"><a href=\"AddComplexWorkoutToFlock.aspx?flockName={flock.Key}\">Add Workout</a></button>\r\n " +
                $"<br/>Members:<br/><ul>");
                
                if(flock.Value.athletesUserNames != null)
                {
                    foreach(string athleteName in flock.Value.athletesUserNames)
                    {
                        Response.Write($"<li>{athleteName}</li>");
                    }
                }
                else
                {
                    Response.Write("No members");
                }
                

                 Response.Write("</ul></fieldset><br/>"); 
            }
        }

    }
}