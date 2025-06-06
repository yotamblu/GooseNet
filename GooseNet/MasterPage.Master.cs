﻿using System;
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
                Response.Write("  <div class=\"topNavItem\"><a href=\"LogIn.aspx\">Log In</a></div>\r\n            <div class=\"topNavItem\"><a href=\"Register.aspx\">Register</a></div>");
            }
        }
        protected void ShowLogoutBtn()
        {
            if (Session["userName"] != null)
            {
                Response.Write($"<button style=\"margin-left:{(Session["role"].ToString() == "athlete" ? "10" : "20")}vw;\" id=\"logoutBtn\"><img src=\"Images/logout.png\" width=\"20\" ></button>");
            }
        }

        protected void ShowConnectButton()
        {
            if (Session["userName"] != null && Session["role"].ToString() == "athlete" && !(bool)Session["connected"])
            {
                Response.Write("<div class=\"topNavItem\"><a href=\"GetOAuthTokenandSecret.aspx\">Connect</a></div>");
            }
        }

        protected void ShowSleepButton()
        {
            if (Session["userName"] != null && Session["role"].ToString() == "athlete")
            {
                Response.Write($"<div class=\"topNavItem\"><a href=\"athleteSleep.aspx?athleteName={Session["userName"].ToString()}\">Sleep</a></div>");
            }
        }

        protected void ShowConnectToCoachButton()
        {
            if (Session["userName"] != null && Session["role"].ToString() == "athlete")
            {
                Response.Write("<div class=\"topNavItem\"><a href=\"ConnectToCoach.aspx\">Connect To Coach</a></div>");
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
        protected void ShowFlocksButton()
        {
            if (Session["userName"] != null && Session["role"].ToString() == "coach")
            {
                Response.Write(" <div class=\"topNavItem\"><a href=\"FlocksMenu.aspx\">Flocks</a></div>");
            }
        }

        protected void ShowActivitiesButton()
        {
            if (Session["userName"] != null && Session["role"].ToString() == "athlete" && (bool)Session["connected"])
            {
                Response.Write($" <div class=\"topNavItem\"><a href=\"AthleteWorkouts.aspx?athleteName={Session["userName"].ToString()}\">Activities</a></div>");
            }
        }


        protected void ShowPlannedWorkoutsButton()
        {
            if (Session["userName"] != null && Session["role"].ToString() == "athlete")
            {
                Response.Write($" <div class=\"topNavItem\"><a href=\"PlannedWorkouts.aspx?athleteName={Session["userName"].ToString()}\">Planned Workouts</a></div>");

            }
        }

    }
}