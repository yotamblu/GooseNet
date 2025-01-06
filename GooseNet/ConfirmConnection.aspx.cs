using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Diagnostics.Eventing.Reader;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class ConfirmConnection : System.Web.UI.Page
    {

        protected string CoachName { get; set; }
        private FirebaseService firebaseService;
        protected void Page_Load(object sender, EventArgs e)
        {

            CheckForAccess();
            firebaseService = new FirebaseService();    
        }



        



      

        public string GetCoachName() {

            Dictionary<string, CoachIdRow> coaches = firebaseService.GetData<Dictionary<string, CoachIdRow>>("CoachCodes");
            foreach(KeyValuePair<string,CoachIdRow> coachData in  coaches)
            {
                if (coachData.Value.CoachId == Request.QueryString["CoachId"].ToString())
                {
                    return coachData.Key;
                }
            }
            Session["CoachNotFoundError"] = true;
            Response.Redirect("ConnectToCoach.aspx");
            //already gone by now
            return null;
        }

        public void CheckForAccess()
        {
            if (Session["userName"] == null)
            {
                Response.Redirect("NoAccess.aspx");
            }
        }
    }
}