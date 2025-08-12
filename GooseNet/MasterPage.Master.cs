using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class MasterPage : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        protected void ShowProfilePic()
        {
            if (Session["userName"] != null)
            {
                Response.Write($"<a href=\"AccMgmtMenu.aspx\"><img id=\"profilePic\" width=\"75\" src=\"{Session["picString"]}\"></a>");
            }
        }

        protected void LogOut(object sender, EventArgs e)
        {
            Session.Abandon();
        }

        protected void ShowLoginButtons()
        {
            if (Session["userName"] == null)
            {
                // Styled for consistency: padding, text color, hover effects, rounded corners.
                Response.Write("<a href=\"LogIn.aspx\" class=\"px-4 py-2 text-white hover:text-cyan-300 transition-colors duration-300 font-medium rounded-full hover:bg-white/10\">Log In</a>");
                Response.Write("<a href=\"Register.aspx\" class=\"bg-white text-blue-600 font-semibold px-5 py-2 rounded-full hover:bg-opacity-90 transform hover:scale-105 transition-all duration-300 shadow-md\">Join for Free</a>");
            }
        }

        protected void ShowLogoutBtn()
        {
            if (Session["userName"] != null)
            {
                // The image itself is written. The parent <a> tag in MasterPage.Master should have
                // 'hover:bg-transparent hover:shadow-none' to prevent unwanted hover effects.
                // The image is styled for visibility on dark backgrounds.
                Response.Write("<img src=\"Images/logout.png\" width=\"20\" alt=\"Logout\" class=\"w-7 h-7 filter brightness-0 invert\">");
            }
        }

        protected void ShowConnectButton()
        {
            if (Session["userName"] != null && Session["role"].ToString() == "athlete" && !(bool)Session["connected"])
            {
                // Styled for consistency: padding, text color, hover effects, rounded corners.
                Response.Write("<a href=\"GetOAuthTokenandSecret.aspx\" class=\"px-4 py-2 text-white hover:text-cyan-300 transition-colors duration-300 font-medium rounded-full hover:bg-white/10\">Connect Garmin</a>");
            }
        }

        protected void ShowSleepButton()
        {
            if (Session["userName"] != null && Session["role"].ToString() == "athlete")
            {
                // Styled for consistency: padding, text color, hover effects, rounded corners.
                Response.Write($"<a href=\"athleteSleep.aspx?athleteName={Session["userName"].ToString()}\" class=\"px-4 py-2 text-white hover:text-cyan-300 transition-colors duration-300 font-medium rounded-full hover:bg-white/10\">Sleep Data</a>");
            }
        }

        protected void ShowConnectToCoachButton()
        {
            if (Session["userName"] != null && Session["role"].ToString() == "athlete")
            {
                // Styled for consistency: padding, text color, hover effects, rounded corners.
                Response.Write("<a href=\"ConnectToCoach.aspx\" class=\"px-4 py-2 text-white hover:text-cyan-300 transition-colors duration-300 font-medium rounded-full hover:bg-white/10\">Connect To Coach</a>");
            }
        }


        protected void ShowConnectAthleteButton()
        {
            if (Session["userName"] != null && Session["role"].ToString() == "coach")
            {
                // Styled for consistency: padding, text color, hover effects, rounded corners.
                Response.Write(" <a href=\"ConnectAthlete.aspx\" class=\"px-4 py-2 text-white hover:text-cyan-300 transition-colors duration-300 font-medium rounded-full hover:bg-white/10\">Connect Athlete</a>");
            }
        }

        protected void ShowAthletesButton()
        {
            if (Session["userName"] != null && Session["role"].ToString() == "coach")
            {
                // Styled for consistency: padding, text color, hover effects, rounded corners.
                Response.Write(" <a href=\"MyAthletes.aspx\" class=\"px-4 py-2 text-white hover:text-cyan-300 transition-colors duration-300 font-medium rounded-full hover:bg-white/10\">Athletes</a>");
            }
        }

        protected void ShowFlocksButton()
        {
            if (Session["userName"] != null && Session["role"].ToString() == "coach")
            {
                // Styled for consistency: padding, text color, hover effects, rounded corners.
                Response.Write(" <a href=\"FlocksMenu.aspx\" class=\"px-4 py-2 text-white hover:text-cyan-300 transition-colors duration-300 font-medium rounded-full hover:bg-white/10\">Flocks</a>");
            }
        }

        protected void ShowActivitiesButton()
        {
            if (Session["userName"] != null && Session["role"].ToString() == "athlete" && (bool)Session["connected"])
            {
                // Styled for consistency: padding, text color, hover effects, rounded corners.
                Response.Write($" <a href=\"AthleteWorkouts.aspx?athleteName={Session["userName"].ToString()}\" class=\"px-4 py-2 text-white hover:text-cyan-300 transition-colors duration-300 font-medium rounded-full hover:bg-white/10\">Activities</a>");
            }
        }


        protected void ShowPlannedWorkoutsButton()
        {
            if (Session["userName"] != null && Session["role"].ToString() == "athlete")
            {
                // Styled for consistency: padding, text color, hover effects, rounded corners.
                Response.Write($" <a href=\"PlannedWorkouts.aspx?athleteName={Session["userName"].ToString()}\" class=\"px-4 py-2 text-white hover:text-cyan-300 transition-colors duration-300 font-medium rounded-full hover:bg-white/10\">Planned Workouts</a>");
            }
        }
    }
}
