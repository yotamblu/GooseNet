<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="MyAthletes.aspx.cs" Inherits="GooseNet.MyAthletes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Athletes - GooseNet</title>
    <style>
          .athlete-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 24px;
      max-width: 1200px;
      margin: 0 auto;
    }

    .athlete-card {
      background-color: #ffffff;
      border-radius: 16px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      padding: 24px;
      text-align: center;
      box-sizing: border-box;
    }

    .profile-pic {
      width: 120px;
      height: 120px;
      border-radius: 50%;
      margin: 0 auto 16px;
      border: 3px solid #00aaff;
      object-fit: cover;
    }

    .username {
      font-size: 1.4rem;
      color: #333333;
      margin: 0 0 20px 0;
    }

    .athlete-button {
      background-color: #00aaff;
      color: #fff;
      border: none;
      border-radius: 8px;
      padding: 12px 24px;
      font-size: 1rem;
      cursor: pointer;
      transition: background-color 0.3s ease;
    }

    .athlete-button:hover {
      background-color: #008fcc;
    }

    
   @media screen and (max-width: 768px) {
      .athlete-grid {
        grid-template-columns: 1fr;
        padding: 0 16px;
      }
    }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<%--    <center>   <%ShowConnectedAthletes(GetConnectedAthletes()); %>--%>

     <div class="athlete-grid">
    <%ShowConnectedAthletes(GetConnectedAthletes()); %>
  </div>


</asp:Content>
