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

            if (coachFlocks == null || coachFlocks.Count == 0)
            {
                Response.Write(@"
            <div class=""glass-panel rounded-xl p-6 mb-6 shadow-lg text-center max-w-md mx-auto"">
                <span class=""text-xl font-bold text-gray-300"">You haven't created any flocks yet.</span>
            </div>");
                return;
            }

            foreach (KeyValuePair<string, Flock> flock in coachFlocks)
            {
                Response.Write($@"
        <div class=""glass-panel rounded-xl p-6 mb-6 shadow-lg transition-all duration-300 hover:shadow-xl hover:scale-[1.01] max-w-md mx-auto"">
            <h2 class=""text-2xl font-bold text-blue-300 mb-4"">{flock.Key}</h2>
            
            <a href=""WorkoutSourceSelection.aspx?flockName={flock.Key}""
               class=""inline-block px-6 py-3 bg-blue-600 text-white font-semibold rounded-full shadow-md hover:bg-blue-700 transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-75 mb-4"">
                Add Workout
            </a>
            
            <h3 class=""text-lg font-semibold text-white mt-4 mb-2"">Members:</h3>
            <ul class=""list-disc list-inside text-gray-300 space-y-1"">");

                if (flock.Value.athletesUserNames != null && flock.Value.athletesUserNames.Any())
                {
                    foreach (string athleteName in flock.Value.athletesUserNames)
                    {
                        Response.Write($"                <li>{athleteName}</li>");
                    }
                }
                else
                {
                    Response.Write("                <li class=\"italic text-gray-400\">No members in this flock yet.</li>");
                }

                Response.Write(@"
            </ul>
        </div>");
            }
        }


    }
}