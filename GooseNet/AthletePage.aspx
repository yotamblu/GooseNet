<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AthletePage.aspx.cs" Inherits="GooseNet.AthletePage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Athlete Profile</title>
  <style>
     /* Background with subtle vertical gradient for depth */
   .athlete-profile {
      background-color: #222228;
      border-radius: 20px;
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.8);
      max-width: 900px;
      width: 100%;
      padding: 48px 48px 56px;
      box-sizing: border-box;
      text-align: center;
      color: #e0e0e0;
    }

    .profile-pic {
      width: 180px;
      height: 180px;
      border-radius: 50%;
      border: 4px solid #00aaff;
      object-fit: cover;
      margin-bottom: 40px;
      transition: transform 0.3s ease;
    }

    .profile-pic:hover {
      transform: scale(1.05);
    }

    .username {
      font-size: 3rem;
      margin: 0 0 48px 0;
      font-weight: 700;
      letter-spacing: 1px;
      word-break: break-word;
      color: #fff;
    }


    .athlete-profile a {
  all: unset;          /* reset all inherited styles */
  display: inline-block; /* keep inline-block so it wraps button */
  cursor: pointer;      /* pointer cursor on hover */
  text-decoration: none;
}

/* Optional: if you want full width clickable buttons, make <a> block and width 100% */
.athlete-profile a {
    margin-top:2%;
  display: block;
  width: 100%;
}

/* Make sure button inside <a> keeps width and styles */
.athlete-profile a button.action-button {
  width: 100%;
  margin: 0 auto;
}

    .action-button {
      display: block;
      width: 320px;
      max-width: 90vw;
      margin: 16px auto;
      padding: 18px;
      font-size: 1.25rem;
      background-color: #00aaff;
      color: white;
      border: none;
      border-radius: 14px;
      cursor: pointer;
      transition: background-color 0.3s ease, transform 0.2s ease;
      font-weight: 600;
      box-shadow: 0 5px 10px rgba(0, 170, 255, 0.4);
    }

    .action-button:hover {
      background-color: #008fcc;
      transform: translateY(-3px);
      box-shadow: 0 10px 20px rgba(0, 143, 204, 0.6);
    }

    /* Responsive adjustments */
    @media (max-width: 600px) {
      .athlete-profile {
        padding: 32px 24px 40px;
        max-width: 100%;
      }

      .profile-pic {
        width: 140px;
        height: 140px;
        margin-bottom: 32px;
      }

      .username {
        font-size: 2rem;
        margin-bottom: 36px;
      }

      .action-button {
        width: 100%;
        font-size: 1.1rem;
        padding: 14px;
        margin: 12px auto;
      }
    }
      </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <center>
<div class="content-wrapper">
    <div class="athlete-profile">
      <img
        src=<%=$"\"{GooseNet.GooseNetUtils.GetUserPicStringByUserName(Request.QueryString["athleteName"])}\"" %>
        alt="Athlete Profile Picture"
        class="profile-pic"
      />
      <h2 class="username">@<%=Request.QueryString["athleteName"] %></h2>

      <a href="PlannedWorkouts.aspx?athleteName=<%=Request.QueryString["athleteName"] %>&coachName=<%=Session["userName"].ToString() %>"><button class="action-button">Planned Workouts</button></a>
      <a href="WorkoutSourceSelection.aspx?athleteName=<%=Request.QueryString["athleteName"] %>"><button class="action-button">Add Workout</button></a>
      <a href="AthleteWorkouts.aspx?athleteName=<%=Request.QueryString["athleteName"] %>"><button class="action-button">Completed Workouts</button></a>
      <a href="AddToFlock.aspx?athleteName=<%=Request.QueryString["athleteName"] %>"><button class="action-button">Add To Flock</button></a>
      <a href="AthleteSleep.aspx?athleteName=<%=Request.QueryString["athleteName"] %>"><button class="action-button">Sleep Data</button></a>
      <a href="AthleteSummary.aspx?athleteName=<%=Request.QueryString["athleteName"] %>"><button class="action-button">Training Summary</button></a>
    </div>
     </div>
    </center>
 
</asp:Content>
