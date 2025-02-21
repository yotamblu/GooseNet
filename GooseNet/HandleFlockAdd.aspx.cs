using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class HandleFlockAdd : System.Web.UI.Page
    {
        private FirebaseService firebaseService;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!GooseNetUtils.IsConnectedToUser(Session, Request.QueryString["athleteName"].ToString()))
            {
                Response.Redirect("NoAccess.aspx");
            }

            firebaseService = new FirebaseService();
            if (firebaseService.GetData<Flock>($"Flocks/{Session["userName"].ToString()}/{Request.QueryString["flockName"]}") == null )
            {
                Response.Redirect("NoAccess.aspx");

            }
            AddAthleteToFlock();
            Response.Redirect("MyAthletes.aspx");
        }

        private void AddAthleteToFlock()
        {

            string flockAthletesListPath = $"Flocks/{Session["userName"].ToString()}/{Request.QueryString["flockName"]}/athletesUserNames";
            List<string> flockAthletes = firebaseService.GetData<List<string>>(flockAthletesListPath);
            if (flockAthletes[0] == "")
            {
                List<string> newFlockAthletes = new List<string>() ;
                newFlockAthletes.Add(Request.QueryString["athleteName"]); 
                firebaseService.InsertData(flockAthletesListPath, newFlockAthletes);
            }
            else
            {
                flockAthletes.Add(Request.QueryString["athleteName"]);
                firebaseService.InsertData(flockAthletesListPath, flockAthletes);
            }

        }       
    }
}