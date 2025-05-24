<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="LogIn.aspx.cs" Inherits="GooseNet.LogIn" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        form{
            top:60%;
        }
    </style>
    <title>GooseNet - Log In</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
       <form method="post" action="HandleLogin.aspx">
        <h3>Login Here</h3>

        <label for="username">Username</label>
        <input type="text" name="userName" placeholder="Username" id="username">

        <label for="password">Password</label>
        <input name="password" type="password" placeholder="Password" id="password">

        <button  id="formButton">Log In</button>
         
               


           </form>

    
</asp:Content>
