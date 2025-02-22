<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="GooseNet.ChangePassword" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
              form {
                position: relative;
                width: fit-content;
                background-color: rgba(255,255,255,0.13);
                 margin: auto;
                 margin-top:5vh;
                top: initial;
                left: initial;
                transform: none;
                border-radius: 10px;
                backdrop-filter: blur(10px);
                border: 2px solid rgba(255,255,255,0.1);
                box-shadow: 0 0 40px rgba(8,7,16,0.6);
                padding: 5vw 20vh;
              }
    </style>
        <title>Change Password</title>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <center><%ShowErrorMessages(); %></center>
    <form action="HandlePasswordChange.aspx" method="post">

        <input name="newPassword" type="password"  placeholder="Your New Password"/><br /><br />
        <input name="passwordRepeat" type="password" placeholder="Your New Password(Again!)"/><br /><br />
        <button  type="submit" id="submitBtn" >Change Password</button>

    </form>
    
</asp:Content>
