using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.BUS;
using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DAO;
using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Controllers.Library
{
    public class DangKyController : Controller
    {
        // GET: DangKy
        public ActionResult NhapThongTin()
        {
            if(Session["phanquyen"].ToString() != "u")
            {
                return Redirect("/TrangChu/Xem");
            }
            return View("~/Views/Library/DangKy/NhapThongTin.cshtml");
        }

        [ValidateInput(false)]
        public ActionResult ThucHienDangKy()
        {
            if (Session["phanquyen"].ToString() != "u")
            {
                return Redirect("/TrangChu/Xem");
            }
            NguoiDung_DTO nguoidung = new NguoiDung_DTO();
            try
            {
                nguoidung.Tendangnhap = Request.Form["tendangnhap"].ToString();
                nguoidung.Matkhau = Request.Form["matkhau"].ToString();
                nguoidung.Ngaysinh = DateTime.Parse(Request.Form["ngaysinh"].ToString());
                nguoidung.Hovaten = Request.Form["hovaten"].ToString();
                nguoidung.Diachi = Request.Form["diachi"].ToString();
                nguoidung.Email = Request.Form["email"].ToString();
                nguoidung.Sodienthoai = Request.Form["sodienthoai"].ToString();
                nguoidung.Gioitinh = Request.Form["gioitinh"].ToString();
                nguoidung.Motangan = Request.Form["motangan"].ToString();
                nguoidung.Maloainguoidung = "2";
                nguoidung.Khoanguoidung = "U";

                if(Request.Files["anhdaidien"]!=null&& Request.Files["anhdaidien"].ContentLength > 0)
                {
                    nguoidung.Anhdaidien = "Y";
                }

                string tenanhphailuu = NguoiDung_BUS.ThemNguoiDungMoi(nguoidung);

                if (Request.Files["anhdaidien"] != null && Request.Files["anhdaidien"].ContentLength > 0)
                {
                    Image image = Image.FromStream(Request.Files["anhdaidien"].InputStream);
                    Bitmap anhfullsize = XuLyAnh.DoiKichThuocAnh(image, 300, 300);
                    anhfullsize.Save(System.AppDomain.CurrentDomain.BaseDirectory + "/Content/upload/avatar/" + tenanhphailuu);
                    Bitmap anhminisize = XuLyAnh.DoiKichThuocAnh(image, 100, 100);
                    anhminisize.Save(System.AppDomain.CurrentDomain.BaseDirectory + "/Content/upload/avatar/thumbnail/" + tenanhphailuu);
                }
            }
            catch (Exception)
            {
                ViewBag.message = "Có lỗi khi nhập thông tin đăng ký, bạn vui lòng nhập lại";
                ViewBag.nguoidung = nguoidung;
                return View("~/Views/Library/DangKy/NhapLaiThongTin.cshtml");
            }

            return Redirect("/DangNhap/NhapThongTin");
        }
    }
}