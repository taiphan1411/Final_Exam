using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.BUS;
using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Controllers.Library
{
    public class DangNhapController : Controller
    {
        // GET: DangNhap
        public ActionResult NhapThongTin()
        {
            if (Session["phanquyen"] != "u")
            {
                return Redirect("/TrangChu/Xem");
            }
            return View("~/Views/Library/DangNhap/NhapThongTin.cshtml");
        }
       
       public ActionResult ThucHienDangNhap(string tendangnhap, string matkhau)
       {
            if (Session["phanquyen"] != "u")
            {
                return Redirect("/TrangChu/Xem");
            }
            try
            { 
                NguoiDung_DTO nguoidung = NguoiDung_BUS.LayThongTinNguoiDungBoiUsernameVaPassword(tendangnhap, matkhau);
                if (nguoidung != null)
                {
                    Session["manguoidung"] = nguoidung.Manguoidung;
                    Session["hovaten"] = nguoidung.Hovaten;
                    Session["phanquyen"] = nguoidung.Phanquyen;
                    Session["anhdaidien"] = nguoidung.Anhdaidien;
                    return Redirect("/TrangChu/Xem");
                }
                else
                {
                    ViewBag.errormessage = "Tên đăng nhập và mật khẩu không đúng, vui lòng nhập lại";
                    return View("~/Views/Library/DangNhap/NhapThongTin.cshtml");
                }
            }
            catch (Exception ex)
            {
                ViewBag.errormessage = "Lỗi khi thực hiện đăng nhập, vui lòng nhập lại";
                return View("~/Views/Library/DangNhap/NhapThongTin.cshtml");
            }
        }

        public ActionResult ThucHienDangXuat()
       {
            if (Session["phanquyen"] != "u")
            {
                return Redirect("/TrangChu/Xem");
            }
            Session["manguoidung"] = "";
            Session["hovaten"] = "";
            Session["phanquyen"] = "u";
            Session["anhdaidien"] = "";

           if (Request.Cookies["tendangnhap"] != null && Request.Cookies["matkhau"] != null)
           {
               Response.Cookies["tendangnhap"].Expires = DateTime.Now.AddDays(-1);
               Response.Cookies["matkhau"].Expires = DateTime.Now.AddDays(-1);
           }    
           return Redirect("/TrangChu/Xem");
       }
    }
}