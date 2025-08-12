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
            if (FlockNames == null || FlockNames.Count == 0)
            {
                Response.Write(@"
            <span class=""text-center text-xl font-bold text-gray-300 p-8 rounded-lg glass-panel"">
                No flocks found to add this athlete to.
            </span>");
                return;
            }

            foreach (string flockName in FlockNames)
            {
                // Ensure the path is correct for your Firebase structure
                // Assuming "Flocks/{CoachUserName}/{FlockName}/athletesUserNames"
                List<string> athletesInFlock = firebaseService.GetData<List<string>>($"Flocks/{Session["userName"]}/{flockName}/athletesUserNames");

                // Check if athletesInFlock is null or if it contains the athlete
                if (athletesInFlock == null || !athletesInFlock.Contains(Request.QueryString["athleteName"]))
                {
                    Response.Write($@"
            <div class=""glass-panel rounded-xl p-6 mb-6 shadow-lg transition-all duration-300 hover:shadow-xl hover:scale-[1.01] flex flex-col items-center justify-between text-center max-w-sm mx-auto"">
                <span class=""text-2xl font-bold text-white mb-4"">{flockName}</span>
                <a href=""HandleFlockAdd.aspx?athleteName={Request.QueryString["athleteName"]}&flockName={flockName}""
                   class=""inline-block px-6 py-3 bg-blue-600 text-white font-semibold rounded-full shadow-md hover:bg-blue-700 transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-75"">
                    Add To Flock
                </a>
            </div>");
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