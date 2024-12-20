<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ConnectToCoach.aspx.cs" Inherits="GooseNet.ConnectToCoach" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>

        button{
            border-radius:12px;
            margin-top:3vh;
            color:black;
            width:10vw;
            height:3vh;
            font-size:1vw;
        }

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <form action="ConfirmConnection.aspx" method="get" style="margin-top:-10%">
        <h3>Enter CoachID Here!</h3>
        <label for="coachId">CoachID</label>
        <input type="text"  name="CoachId" id="coachId"/>
       <center> <button type="submit">Connect</button></center>
    </form>
</asp:Content>
