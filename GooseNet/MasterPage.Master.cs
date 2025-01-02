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
       

        protected void ShowHelloUser()
        {
            if (Session["userName"] != null)
            {
                Response.Write($"Hello,{Session["username"].ToString()}");
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
                Response.Write("  <div class=\"topNavItem\"><a href=\"LogIn.aspx\">Log In</a></div>\r\n            <div class=\"topNavItem\"><a href=\"Register.aspx\">Register</a></div>");
            }
        }
        protected void ShowLogoutBtn()
        {
            if (Session["userName"] != null)
            {
                Response.Write("<button style=\"margin-left:30vw;\"><img src=\"Images/logout.png\" width=\"20\"></button>");
            }
        }

        protected void ShowConnectButton()
        {
            if (Session["userName"] != null && Session["role"].ToString() == "athlete" && !(bool)Session["connected"])
            {
                Response.Write(" <div class=\"topNavItem\"><a href=\"GetOAuthTokenandSecret.aspx\">Connect</a></div>");
            }
        }

        protected void ShowConnectToCoachButton()
        {
            if (Session["userName"] != null && Session["role"].ToString() == "athlete")
            {
                Response.Write("<div class=\"topNavItem\"><a href=\"ConnectToCoach.aspx\">Connect To Coach</a></div>\"");
            }
        }


        protected void ShowConnectAthleteButton()
        {
            if (Session["userName"] != null && Session["role"].ToString() == "coach")
            {
                Response.Write(" <div class=\"topNavItem\"><a href=\"ConnectAthlete.aspx\">Connect Athlete</a></div>");
            }
        }

        protected void ShowAthletesButton()
        {
            if (Session["userName"] != null && Session["role"].ToString() == "coach")
            {
                Response.Write(" <div class=\"topNavItem\"><a href=\"MyAthletes.aspx\">Athletes</a></div>");
            }
        }
        
    }
}