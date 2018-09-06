using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO
{
    public class Sach_DTO
    {
        private int masach;
        private string tensach;
        private string anh;
        private DateTime ngaydang;
        private string tacgia;

        public Sach_DTO(int masach, string tensach, string anh, DateTime ngaydang, string tacgia)
        {
            this.masach = 1;
            this.tensach = "";
            this.anh = "noimage.jpg";
            this.ngaydang = new DateTime(1,1,1);
            this.tacgia = "";
        }

        public Sach_DTO()
        {
        }

        public int Masach
        {
            get
            {
                return masach;
            }

            set
            {
                masach = value;
            }
        }

        public string Tensach
        {
            get
            {
                return tensach;
            }

            set
            {
                tensach = value;
            }
        }

        public string Anh
        {
            get
            {
                return anh;
            }

            set
            {
                anh = value;
            }
        }

        public DateTime Ngaydang
        {
            get
            {
                return ngaydang;
            }

            set
            {
                ngaydang = value;
            }
        }

        public string Tacgia
        {
            get
            {
                return tacgia;
            }

            set
            {
                tacgia = value;
            }
        }
    }
}