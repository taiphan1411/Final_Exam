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
            if (Session["phanquyen"].ToString() != "u")
            {
                return Redirect("/KhoSach/DuyetKhoSach");
            }
            return View("~/Views/Library/DangNhap/NhapThongTin.cshtml");
        }
       
       public ActionResult ThucHienDangNhap(string tendangnhap, string matkhau, string check_ghinho)
       {
            if (Session["phanquyen"].ToString() != "u")
            {
                return Redirect("/KhoSach/DuyetKhoSach");
            }
            try
            {
                bool coghinho;
                if (check_ghinho == "true")
                {
                    coghinho = true;
                }
                else
                {
                    coghinho = false;
                }
                NguoiDung_DTO nguoidung = NguoiDung_BUS.LayThongTinNguoiDungBoiUsernameVaPassword(tendangnhap, matkhau);
                if (nguoidung != null)
                {
                    Session["manguoidung"] = nguoidung.Manguoidung;
                    Session["hovaten"] = nguoidung.Hovaten;
                    Session["phanquyen"] = nguoidung.Phanquyen;
                    Session["anhdaidien"] = nguoidung.Anhdaidien;

                    if (Session["phanquyen"].ToString() == "me")
                    {
                        Session["items"] = new List<Item_DTO>();
                    }

                    if (coghinho == true)
                    {
                        Response.Cookies["tendangnhap"].Value = nguoidung.Tendangnhap;
                        Response.Cookies["tendangnhap"].Expires = DateTime.Now.AddMonths(1);
                        Response.Cookies["matkhau"].Value = nguoidung.Matkhau;
                        Response.Cookies["matkhau"].Expires = DateTime.Now.AddMonths(1);
                    }

                    return Redirect("/KhoSach/DuyetKhoSach");
                }
                else
                {
                    ViewBag.errormessage = "Tên đăng nhập và mật khẩu không đúng, vui lòng nhập lại";
                    return View("~/Views/Library/DangNhap/NhapThongTin.cshtml");
                }
            }
            catch (Exception)
            {
                ViewBag.errormessage = "Lỗi khi thực hiện đăng nhập, vui lòng nhập lại";
                return View("~/Views/Library/DangNhap/NhapThongTin.cshtml");
            }
        }

        public ActionResult ThucHienDangXuat()
       {
            if (Session["phanquyen"].ToString() == "u")
            {
                return Redirect("/KhoSach/DuyetKhoSach");
            }
            Session["manguoidung"] = "";
            Session["hovaten"] = "";
            Session["phanquyen"] = "u";
            Session["anhdaidien"] = "";

            if (Session["items"] != null)
            {
                Session.Remove("items");
            }

            if (Request.Cookies["tendangnhap"] != null && Request.Cookies["matkhau"] != null)
            {
                Response.Cookies["tendangnhap"].Expires = DateTime.Now.AddDays(-1);
                Response.Cookies["matkhau"].Expires = DateTime.Now.AddDays(-1);
            }    
            return Redirect("/KhoSach/DuyetKhoSach");
       }
    }
}