using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace GooseNet
{
    public partial class AddToFlock : System.Web.UI.Page
    {

        private FirebaseService firebaseService;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!GooseNetUtils.IsConnectedToUser(Session,Request.QueryString["athleteName"].ToString()))
            {
                Response.Redirect("NoAccess.aspx");
            }
            firebaseService = new FirebaseService();
        }


        protected void ShowConnectionButtons()
        {

            List<string> FlockNames = GetCoachFlocks();
            for (int i = 0; i < FlockNames.Count; i++)
            {
                string flockName = FlockNames.ElementAt(i);
                if (!firebaseService.GetData<List<string>>($"Flocks/{Session["userName"]}/{flockName}/athletesUserNames").Contains(Request.QueryString["athleteName"]))
                {
                    Response.Write(" <fieldset>\r\n " +
                  $"<span class=\"athleteName\">{flockName}</span><br/>\r\n        " +
                 $"<button class=\"workoutBtns\"><a href=\"HandleFlockAdd.aspx?athleteName={Request.QueryString["athleteName"]}&flockName={flockName}\">Add To Flock</a></button>\r\n " +

                  "   </fieldset><br/>");
                }

              
            }
        }

        protected List<string> GetCoachFlocks()
        {
            List<string> flocks = new List<string>();
            Dictionary<string, Flock> rows = firebaseService.GetData<Dictionary<string, Flock>>($"Flocks/{Session["userName"].ToString()}");
            foreach (KeyValuePair<string, Flock> kvp in rows)
            {
                    flocks.Add(kvp.Value.FlockName);
            }
            return flocks;
        }
    }
}