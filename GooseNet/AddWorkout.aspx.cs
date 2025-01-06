using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{


    public partial class AddWorkout : System.Web.UI.Page
    {
        FirebaseService firebaseService;
        public void CheckForAccess()
        {
            if (Session["userName"] == null)
            {
                Response.Redirect("NoAccess.aspx");
            }
            firebaseService = new FirebaseService();
        }


        

        protected void Page_Load(object sender, EventArgs e)
        {

            CheckForAccess();
            if (!IsConnected()){
                Response.Redirect("NoAccess.aspx");
            }
        }

        private bool IsConnected()
        {
            Dictionary<string, AthleteCoachConnection> rows = firebaseService.GetData<Dictionary<string, AthleteCoachConnection>>("AthleteCoachConnections");
            if(rows == null)
            {
                return false;
            }
            else
            {
                foreach(KeyValuePair<string,AthleteCoachConnection> kvp in  rows)
                {
                    if (kvp.Value.CoachUserName == Session["userName"].ToString() && kvp.Value.AthleteUserName == Request.QueryString["athleteName"].ToString())
                    {
                        return true;
                    }
                }
            }
            return false;
        
        }

      

    }
}