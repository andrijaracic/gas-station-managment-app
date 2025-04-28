using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using BenzinskaPumpa.Shared;
using System.Collections.Generic;
using Xceed.Wpf.Toolkit;

namespace DL_SlojPodataka
{
    public class DLBenzinskaPumpa
    {
        private SqlConnection sc = new SqlConnection();
        private SqlDataAdapter daUsluge = new SqlDataAdapter();
        private DataTable dtUsluge = new DataTable();

        private static DLBenzinskaPumpa instance = null;
        public static DLBenzinskaPumpa Instance
        {
            get
            {
                if (instance == null)
                    instance = new DLBenzinskaPumpa();
                return instance;
            }
        }

        private DLBenzinskaPumpa()
        {
            var conn = ConfigurationManager.ConnectionStrings["BenzinskaPumpa"];
            sc.ConnectionString = conn.ConnectionString;
            LoadUsluge();
        }

        
        private SqlDataAdapter daZaposleni = new SqlDataAdapter();
        private DataTable dtZaposleni = new DataTable();


        



        private void LoadUsluge()
        {
            dtUsluge.Clear();
            var cmd = sc.CreateCommand();
            cmd.CommandType = CommandType.Text;
            cmd.CommandText = "SELECT * FROM Usluga";

            daUsluge.SelectCommand = cmd;
            SqlCommandBuilder cb = new SqlCommandBuilder(daUsluge);

            sc.Open();
            daUsluge.Fill(dtUsluge);
            daUsluge.UpdateCommand = cb.GetUpdateCommand();
            sc.Close();
        }

        private void Update()
        {
            // Ukloni nevalidne redove pre upisa
            foreach (DataRow row in dtUsluge.Rows.Cast<DataRow>().ToList())
            {
                if ((row.RowState == DataRowState.Added || row.RowState == DataRowState.Modified) &&
                    (row["Naziv"] == DBNull.Value || string.IsNullOrWhiteSpace(row["Naziv"].ToString())))
                {
                    dtUsluge.Rows.Remove(row);
                }
            }

            daUsluge.Update(dtUsluge); // pokušaj upisa u bazu

            dtUsluge.AcceptChanges();  // resetuj stanja redova

            LoadUsluge(); // osveži prikaz
        }


        public bool Insert(Usluga u)
        {
            DataRow dr = dtUsluge.NewRow();

            dr["Naziv"] = u.Naziv;
            dr["Opis"] = u.Opis;
            dr["Cena"] = u.Cena;
            dr["KategorijaID"] = u.KategorijaID;

            dtUsluge.Rows.Add(dr);
            foreach (DataRow row in dtUsluge.Rows)
            {
                if (row.RowState == DataRowState.Added || row.RowState == DataRowState.Modified)
                {
                    if (row["Naziv"] == DBNull.Value || string.IsNullOrWhiteSpace(row["Naziv"].ToString()))
                    {
                        
                        return false;
                    }
                }
            }

            Update();
            return true;

            
        }


        public bool Update(Usluga u)
        {
            DataRow dr = dtUsluge.Select("UslugaID = " + u.UslugaID)[0];
            dr["Naziv"] = u.Naziv;
            dr["Opis"] = u.Opis;
            dr["Cena"] = u.Cena;
            dr["KategorijaID"] = u.KategorijaID;

            Update();
            return true;
        }

        public bool Delete(int id)
        {
            dtUsluge.Select("UslugaID = " + id)[0].Delete();
            Update();
            return true;
        }

        public List<Usluga> GetAll()
        {
            List<Usluga> lista = new List<Usluga>();
            foreach (DataRow dr in dtUsluge.Rows)
            {
                lista.Add(Convert(dr));
            }
            return lista;
        }

        public Usluga GetById(int id)
        {
            DataRow dr = dtUsluge.Select("UslugaID = " + id)[0];
            return Convert(dr);
        }

        public List<Usluga> GetUslugeByKategorija(int kategorijaID)
        {
            List<Usluga> usluge = new List<Usluga>();

            SqlCommand cmd = new SqlCommand("SELECT * FROM Usluga WHERE KategorijaID = @KategorijaID", sc);
            cmd.Parameters.AddWithValue("@KategorijaID", kategorijaID);

            if (sc.State == ConnectionState.Closed)
                sc.Open();

            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                Usluga u = new Usluga();
                u.UslugaID = reader.GetInt32(reader.GetOrdinal("UslugaID"));
                u.Naziv = reader["Naziv"].ToString();
                u.Opis = reader["Opis"].ToString();
                u.Cena = reader.GetInt32(reader.GetOrdinal("Cena"));
                u.KategorijaID = reader.GetInt32(reader.GetOrdinal("KategorijaID"));

                usluge.Add(u);
            }

            reader.Close();
            sc.Close();

            return usluge;
        }

        public List<Kategorija> GetAllKategorije()
        {
            List<Kategorija> kategorije = new List<Kategorija>();

            SqlCommand cmd = new SqlCommand("SELECT * FROM Kategorija", sc);

            if (sc.State == ConnectionState.Closed)
                sc.Open();

            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                Kategorija k = new Kategorija();
                k.KategorijaID = reader.GetInt32(reader.GetOrdinal("KategorijaID"));
                k.Naziv = reader["Naziv"].ToString();

                kategorije.Add(k);
            }

            reader.Close();
            sc.Close();

            return kategorije;
        }

        private Usluga Convert(DataRow dr)
        {
            int uslugaID;
            decimal cena;
            int kategorijaID;

            return new Usluga
            {
                // TryParse vraća true ako uspešno konvertuje, inače se koristi podrazumevana vrednost
                UslugaID = int.TryParse(dr["UslugaID"].ToString(), out uslugaID) ? uslugaID : 0,
                Naziv = dr["Naziv"] != DBNull.Value ? dr["Naziv"].ToString() : string.Empty,
                Opis = dr["Opis"] != DBNull.Value ? dr["Opis"].ToString() : string.Empty,
                Cena = decimal.TryParse(dr["Cena"].ToString(), out cena) ? cena : 0m,
                KategorijaID = int.TryParse(dr["KategorijaID"].ToString(), out kategorijaID) ? kategorijaID : 0
            };
        }

        




    }
}
