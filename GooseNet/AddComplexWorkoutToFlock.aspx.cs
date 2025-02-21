using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class AddComplexWorkoutToFlock : System.Web.UI.Page
    {

        FirebaseService firebaseService;
        protected void Page_Load(object sender, EventArgs e)
        {
            firebaseService = new FirebaseService();

            if (Session["userName"] == null || Session["role"].ToString() != "coach" || !HasFlock())
            {
                Response.Redirect("NoAccess.aspx");
            }
        }

        private bool HasFlock()
        {
            if (Request.QueryString["flockName"] == null)
            {
                return false;
            }
            Dictionary<string, Flock> coachFlocks = firebaseService.GetData<Dictionary<string, Flock>>($"Flocks/{Session["userName"]}");
            foreach (KeyValuePair<string, Flock> kvp in coachFlocks)
            {
                if (kvp.Key == Request.QueryString["flockName"])
                {
                    return true;
                }
            }
            return false;
        }
    }


}