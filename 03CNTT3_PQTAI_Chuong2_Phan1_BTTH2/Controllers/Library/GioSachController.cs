using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.BUS;
using _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Controllers.Library
{
    public class GioSachController : Controller
    {
        // GET: GioSach
        public ActionResult ThemSach(string madausach, string urlnext)
        {
            if (Session["phanquyen"].ToString() == "u")
            {
                return Redirect("/DangNhap/NhapThongTin");
            }
            if (Session["phanquyen"].ToString() == "ma" || Session["phanquyen"].ToString() == "a")
            {
                return Redirect(urlnext);
            }
            DauSach_DTO dausach = DauSach_BUS.LayThongTinChiTietCuaDauSachBoiMa(madausach);
            if(dausach != null)
            {
                bool cotontai = false;
                foreach(Item_DTO item in (List<Item_DTO>)Session["items"])
                {
                    if(item.Madausach == dausach.Madausach)
                    {
                        item.Soluong = item.Soluong + 1;
                        cotontai = true;
                    }
                }
                if(cotontai == false)
                {
                    Item_DTO item = new Item_DTO();
                    item.Madausach = dausach.Madausach;
                    item.Tensach = dausach.Tensach;
                    item.Bia = dausach.Bia;
                    item.Soluong = 1;
                    ((List<Item_DTO>)Session["items"]).Add(item);
                }
            }
            return Redirect(urlnext);
        }
        public ActionResult XemChiTiet()
        {
            if (Session["phanquyen"].ToString() != "me")
            {
                return Redirect("/KhoSach/DuyetKhoSach");
            }
            return View("~/Views/Library/GioSach/XemChiTiet.cshtml");
        }
        public ActionResult XoaDauSachMuon(string madausach)
        {
            if (Session["phanquyen"].ToString() != "me")
            {
                return Redirect("/KhoSach/DuyetKhoSach");
            }
            List<Item_DTO> items = (List<Item_DTO>)Session["items"];
            foreach (Item_DTO item in items)
            {
                if (item.Madausach == madausach)
                {
                    items.Remove(item);
                    break;
                }
            }
            return Redirect("/GioSach/XemChiTiet");
        }
        public ActionResult SuaThongTin(string madausach)
        {
            if (Session["phanquyen"].ToString() != "me")
            {
                return Redirect("/KhoSach/DuyetKhoSach");
            }
            List<Item_DTO> items = (List<Item_DTO>)Session["items"];
            foreach (Item_DTO item in items)
            {
                if (item.Madausach == madausach)
                {
                    ViewBag.item = item;
                    break;
                }
            }
            return View("~/Views/Library/GioSach/SuaThongTin.cshtml");
        }
        public ActionResult ThucHienCapNhat(string madausach, int soluong)
        {
            if (Session["phanquyen"].ToString() != "me")
            {
                return Redirect("/KhoSach/DuyetKhoSach");
            }
            List<Item_DTO> items = (List<Item_DTO>)Session["items"];
            foreach (Item_DTO item in items)
            {
                if (item.Madausach == madausach)
                {
                    item.Soluong = soluong;
                    ViewBag.item = item;
                    break;
                }
            }
            return View("~/Views/Library/GioSach/XemChiTiet.cshtml");
        }
        public ActionResult DatMuonSach()
        {
            if (Session["phanquyen"].ToString() != "me")
            {
                return Redirect("/KhoSach/DuyetKhoSach");
            }
            List<Item_DTO> items = (List<Item_DTO>)Session["items"];
            string manguoidung = Session["manguoidung"].ToString();
            if(DonDatSach_BUS.ThucHienMuonCacCuonSachTrongGioHang(items, manguoidung) == true)
            {
                ((List<Item_DTO>)Session["items"]).Clear();
                return Redirect("/KhoSach/DuyetKhoSach");
            }
            else
            {
                ViewBag.errormessage = "Giỏ sách không thể trống và số lượng sách không thể vượt quá" + ThamSo_BUS.SoLuongSachToiDaCoTheMuon() + "cuốn sách";
                return View("~/Views/Library/GioSach/XemChiTiet.cshtml");
            }
        }
    }
}