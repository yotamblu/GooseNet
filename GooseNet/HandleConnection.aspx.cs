using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class HandleConnection : System.Web.UI.Page
    {
        private FirebaseService firebaseService;
        public void CheckForAccess()
        {

            if (Session["userName"] == null)
            {
                Response.Redirect("NoAccess.aspx");
            }


        }
        protected void Page_Load(object sender, EventArgs e)
        {
            CheckForAccess();
            firebaseService = new FirebaseService();
            if (Session["role"].ToString() == "coach")
            {
                Response.Redirect("NoAccess.aspx");
            }
            ConnectToCoach();
        }

        private void ConnectToCoach()
        {
            Guid guid = Guid.NewGuid();

            string guidString = guid.ToString("N");

            string uniqueString = guidString.Substring(0, 12);

            AthleteCoachConnection connection = new AthleteCoachConnection
            {
                AthleteUserName = Session["userName"].ToString(),
                CoachUserName = Request.QueryString["CoachName"].ToString()
            };
            firebaseService.InsertData("AthleteCoachConnections/" + uniqueString, connection);
        }
       
    }
}

