<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AddWorkout.aspx.cs" Inherits="GooseNet.AddWorkout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <style>
    button[type=submit]{
        border-radius:10px;
        
    }
    form{
        top:50%;
    }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

  
  <form method="get" action="AddWorkoutS2.aspx?">
    <h1>  Amount Of Workout Intervals:</h1><br />
      <input  type="number" name="intervals" />
      <br /><br />
      <input type="text" name="athleteName" style="display:none;" value="<%=Request.QueryString["athleteName"].ToString() %>"/>
      <button type="submit">Submit</button>
  </form>
</asp:Content>
