
1.	Keterangan
SELECT t1.tgl_transaksi ,t1.kode_cabang , t3.nama_cabang , t4.nama_kota , t5.nama_propinsi , t1.kode_kasir , t7.nama_karyawan , t1.kode_item ,
t2.kode_produk , t2.nama_produk , t6.nama_kategori , t1.jumlah_pembelian 
FROM tr_penjualan t1
INNER JOIN ms_produk t2 ON t1.kode_produk = t2.kode_produk 
INNER JOIN ms_cabang t3 ON t1.kode_cabang = t3.kode_cabang 
INNER JOIN ms_kota t4 ON t4.kode_kota = t3.kode_kota 
INNER JOIN ms_propinsi t5 ON t5.kode_propinsi = t4.kode_propinsi 
INNER JOIN ms_kategori t6 ON t6.kode_kategori = t2.kode_kategori 
INNER JOIN dim_karyawan  t7 ON t7.kode_cabang = t1.kode_cabang 
INNER JOIN ms_harga_harian t8 ON t1.kode_cabang = t8.kode_cabang AND t1.tgl_transaksi = t8.tgl_berlaku AND t1.kode_produk = t8.kode_produk ;

2.	Analisa penjualan
a.	Quantitas (jumlah pembelian)
i.	Keseluruhan
SELECT SUM(jumlah_pembelian) jumlah_pembelian FROM tr_penjualan;

ii.	Percabang
SELECT t1.nama_cabang , SUM(t2.jumlah_pembelian) jumlah_pembelian
FROM ms_cabang t1 INNER JOIN
tr_penjualan t2 ON t1.kode_cabang=t2.kode_cabang GROUP BY
t1.nama_cabang;

iii.	Perkota
SELECT t2.nama_kota, SUM(t3.jumlah_pembelian) jumlah_pembelian
FROM ms_cabang t1 INNER JOIN  
ms_kota t2 ON t1.kode_kota=t2.kode_kota INNER JOIN 
tr_penjualan t3 ON t1.kode_cabang=t3.kode_cabang GROUP BY 
t2.nama_kota;

iv.	Perpropinsi
SELECT t3.nama_propinsi , SUM(t4.jumlah_pembelian) jumlah_pembelian
FROM ms_cabang t1 INNER JOIN
ms_kota t2 ON t1.kode_kota=t2.kode_kota INNER JOIN 
ms_propinsi t3 ON t2.kode_propinsi =t3.kode_propinsi INNER JOIN
tr_penjualan t4 ON t4.kode_cabang=t1.kode_cabang GROUP BY 
t3.nama_propinsi ;

v.	Perproduk
SELECT t1.nama_produk , SUM(t2.jumlah_pembelian) jumlah_pembelian
FROM ms_produk t1 INNER JOIN
tr_penjualan t2 ON t1.kode_produk=t2.kode_produk GROUP BY 
t1.nama_produk ;

vi.	Perkategori
SELECT t3.nama_kategori , SUM(t1.jumlah_pembelian) jumlah_pembelian
FROM tr_penjualan t1 INNER JOIN
ms_produk t2 ON t1.kode_produk =t2.kode_produk INNER JOIN 
ms_kategori t3 ON t2.kode_kategori =t3.kode_kategori GROUP BY
t3.nama_kategori ;

b.	Nilai transaksi
i.	Total pembelian
SELECT SUM(a1.jumlah_pembelian*a2.harga_berlaku_cabang) amount, 
SUM(((a1.jumlah_pembelian*a2.harga_berlaku_cabang)-(a1.jumlah_pembelian*(a2.modal_cabang+a2.biaya_cabang)))) profitt
FROM tr_penjualan a1 INNER JOIN
 ms_harga_harian a2 ON a1.tgl_transaksi=a2.tgl_berlaku AND a1.kode_produk=a2.kode_produk AND a1.kode_cabang = a2.kode_cabang ;
 
ii.	Percabang
SELECT a3.nama_cabang, SUM(a1.jumlah_pembelian*a2.harga_berlaku_cabang) amount, 
SUM(((a1.jumlah_pembelian*a2.harga_berlaku_cabang)-(a1.jumlah_pembelian*(a2.modal_cabang+a2.biaya_cabang)))) profitt
FROM tr_penjualan a1 INNER JOIN ms_harga_harian a2 ON a1.tgl_transaksi=a2.tgl_berlaku AND a1.kode_produk=a2.kode_produk 
AND a1.kode_cabang = a2.kode_cabang INNER JOIN ms_cabang a3 ON a3.kode_cabang=a1.kode_cabang
 GROUP BY a3.nama_cabang;
 
iii.	Perkota
SELECT a1.nama_kota, SUM(a1.amount) amount, SUM(a1.profitt) profitt
FROM
(SELECT t3.nama_kota, (t1.jumlah_pembelian*t4.harga_berlaku_cabang) amount, 
((t1.jumlah_pembelian*t4.harga_berlaku_cabang)-(t1.jumlah_pembelian*(t4.modal_cabang+t4.biaya_cabang))) profitt
FROM tr_penjualan t1
INNER JOIN ms_cabang t2 ON t1.kode_cabang=t2.kode_cabang 
INNER JOIN ms_kota t3 ON t3.kode_kota=t2.kode_kota 
INNER JOIN 
ms_harga_harian t4 ON  t1.tgl_transaksi=t4.tgl_berlaku AND t1.kode_produk=t4.kode_produk AND t1.kode_cabang = t4.kode_cabang) a1
GROUP BY a1.nama_kota;


iv.	Perpropinsi
SELECT a1.nama_propinsi, SUM(a1.amount) amount, SUM(a1.profitt) profitt
FROM
(SELECT t3.nama_propinsi nama_propinsi, (t4.jumlah_pembelian*t5.harga_berlaku_cabang) amount, 
((t4.jumlah_pembelian*t5.harga_berlaku_cabang)-(t4.jumlah_pembelian*(t5.modal_cabang+t5.biaya_cabang))) profitt
FROM ms_cabang t1 INNER JOIN
ms_kota t2 ON t1.kode_kota=t2.kode_kota INNER JOIN 
ms_propinsi t3 ON t2.kode_propinsi =t3.kode_propinsi INNER JOIN
tr_penjualan t4 ON t4.kode_cabang=t1.kode_cabang  INNER JOIN 
ms_harga_harian t5 ON t4.tgl_transaksi=t5.tgl_berlaku AND t4.kode_produk=t5.kode_produk AND t4.kode_cabang = t5.kode_cabang) a1
GROUP BY a1.nama_propinsi;

v.	Perproduk
SELECT a1.nama_produk, SUM(a1.amount) amount, SUM(a1.profitt) profitt
FROM
(SELECT t3.nama_produk, (t1.jumlah_pembelian*t2.harga_berlaku_cabang) amount, 
((t1.jumlah_pembelian*t2.harga_berlaku_cabang)-(t1.jumlah_pembelian*(t2.modal_cabang+t2.biaya_cabang))) profitt
FROM  tr_penjualan t1 
 INNER JOIN ms_harga_harian t2 ON t1.tgl_transaksi=t2.tgl_berlaku AND t1.kode_produk=t2.kode_produk AND t1.kode_cabang = t2.kode_cabang 
 INNER JOIN ms_produk t3 ON t2.kode_produk=t3.kode_produk) a1 GROUP BY a1.nama_produk ;
 
vi.	Perkategori
SELECT a1.nama_kategori, SUM(a1.amount) amount, SUM(a1.profitt) profitt
FROM 
(SELECT t3.nama_kategori nama_kategori, (t1.jumlah_pembelian*t4.harga_berlaku_cabang) amount, 
((t1.jumlah_pembelian*t4.harga_berlaku_cabang)-(t1.jumlah_pembelian*(t4.modal_cabang+t4.biaya_cabang))) profitt
FROM tr_penjualan t1 
INNER JOIN ms_produk t2 ON t1.kode_produk =t2.kode_produk 
INNER JOIN ms_kategori t3 ON t2.kode_kategori =t3.kode_kategori
INNER JOIN ms_harga_harian t4 ON t1.tgl_transaksi=t4.tgl_berlaku AND t1.kode_produk=t4.kode_produk AND t1.kode_cabang = t4.kode_cabang ) a1
GROUP BY a1.nama_kategori;

c.	Total transaksi perbulan
i.	Percabang
SELECT t1.bulan_transaksi, t1.nama_cabang, SUM(t1.jumlah_pembelian) jumlah_pembelian , SUM(t1.amount) amount , SUM(t1.profit) profit
FROM
(SELECT EXTRACT (MONTH FROM a1.tgl_transaksi) bulan_transaksi, a2.nama_cabang nama_cabang, a1.jumlah_pembelian jumlah_pembelian,
(a1.jumlah_pembelian*a3.harga_berlaku_cabang) amount,
((a1.jumlah_pembelian*a3.harga_berlaku_cabang)-(a1.jumlah_pembelian*(a3.biaya_cabang+a3.modal_cabang))) profit
FROM tr_penjualan a1
INNER JOIN ms_cabang a2 ON a1.kode_cabang=a2.kode_cabang
INNER JOIN ms_harga_harian a3 ON a1.tgl_transaksi=a3.tgl_berlaku AND a1.kode_produk=a3.kode_produk AND a1.kode_cabang = a3.kode_cabang) t1
GROUP BY t1.bulan_transaksi, t1.nama_cabang;

ii.	Perkota
SELECT t1.bulan_transaksi, t1.nama_kota, SUM(t1.jumlah_pembelian) jumlah_pembelian , SUM(t1.amount) amount , SUM(t1.profit) profit
FROM
(SELECT EXTRACT (MONTH FROM a1.tgl_transaksi) bulan_transaksi, a4.nama_kota nama_kota, a1.jumlah_pembelian jumlah_pembelian,
(a1.jumlah_pembelian*a3.harga_berlaku_cabang) amount,
((a1.jumlah_pembelian*a3.harga_berlaku_cabang)-(a1.jumlah_pembelian*(a3.biaya_cabang+a3.modal_cabang))) profit
FROM tr_penjualan a1
INNER JOIN ms_cabang a2 ON a1.kode_cabang=a2.kode_cabang
INNER JOIN ms_kota a4 ON a2.kode_kota = a4.kode_kota
INNER JOIN ms_harga_harian a3 ON a1.tgl_transaksi=a3.tgl_berlaku AND a1.kode_produk=a3.kode_produk AND a1.kode_cabang = a3.kode_cabang) t1
GROUP BY t1.bulan_transaksi, t1.nama_kota;

iii.	Perpropinsi
SELECT t1.bulan_transaksi, t1.nama_propinsi, SUM(t1.jumlah_pembelian) jumlah_pembelian , SUM(t1.amount) amount , SUM(t1.profit) profit
FROM
(SELECT EXTRACT (MONTH FROM a1.tgl_transaksi) bulan_transaksi, a5.nama_propinsi nama_propinsi, a1.jumlah_pembelian jumlah_pembelian,
(a1.jumlah_pembelian*a3.harga_berlaku_cabang) amount,
((a1.jumlah_pembelian*a3.harga_berlaku_cabang)-(a1.jumlah_pembelian*(a3.biaya_cabang+a3.modal_cabang))) profit
FROM tr_penjualan a1
INNER JOIN ms_cabang a2 ON a1.kode_cabang=a2.kode_cabang
INNER JOIN ms_kota a4 ON a2.kode_kota = a4.kode_kota
INNER JOIN ms_propinsi a5 ON a4.kode_propinsi = a5.kode_propinsi 
INNER JOIN ms_harga_harian a3 ON a1.tgl_transaksi=a3.tgl_berlaku AND a1.kode_produk=a3.kode_produk AND a1.kode_cabang = a3.kode_cabang) t1
GROUP BY t1.bulan_transaksi, t1.nama_propinsi;

iv.	Perproduk
SELECT t1.bulan_transaksi, t1.nama_produk, SUM(t1.jumlah_pembelian) jumlah_pembelian , SUM(t1.amount) amount , SUM(t1.profit) profit
 FROM 
 (SELECT EXTRACT (MONTH FROM a1.tgl_transaksi) bulan_transaksi, a2.nama_produk nama_produk, a1.jumlah_pembelian jumlah_pembelian, 
 (a1.jumlah_pembelian* a3.harga_berlaku_cabang) amount, 
 ((a1.jumlah_pembelian*a3.harga_berlaku_cabang)-(a1.jumlah_pembelian*(a3.biaya_cabang+a3.modal_cabang))) profit 
 FROM tr_penjualan a1 INNER JOIN ms_produk a2 ON a2.kode_produk = a1.kode_produk  INNER JOIN ms_harga_harian a3 
 ON a1.tgl_transaksi=a3.tgl_berlaku AND a1.kode_produk =a3.kode_produk AND a1.kode_cabang = a3.kode_cabang) t1 
 GROUP BY t1.bulan_transaksi, t1.nama_produk;

d.	Total transaksi pertahun perbulan
i.	Percabang
SELECT y1.bulan_transaksi bulan_transaksi, y1.nama_cabang nama_cabang, 
y1.jumlah_pembelian, SUM(y1.jumlah_pembelian) OVER (PARTITION BY y1.nama_cabang ORDER BY y1.seqnum) YTD_pembelian,
y1.amount, y1.profit
FROM 
(SELECT t1.bulan_transaksi bulan_transaksi , t1.nama_cabang nama_cabang , SUM(t1.jumlah_pembelian) jumlah_pembelian ,
ROW_NUMBER() OVER (PARTITION BY t1.nama_cabang ORDER BY t1.nama_cabang, t1.bulan_transaksi) seqnum,
SUM(t1.amount) amount , SUM(t1.profit) profit
FROM
(SELECT EXTRACT (MONTH FROM a1.tgl_transaksi) bulan_transaksi, a2.nama_cabang nama_cabang, a1.jumlah_pembelian jumlah_pembelian,
(a1.jumlah_pembelian*a3.harga_berlaku_cabang) amount,
((a1.jumlah_pembelian*a3.harga_berlaku_cabang)-(a1.jumlah_pembelian*(a3.biaya_cabang+a3.modal_cabang))) profit
FROM tr_penjualan a1
INNER JOIN ms_cabang a2 ON a1.kode_cabang=a2.kode_cabang
INNER JOIN ms_harga_harian a3 ON a1.tgl_transaksi=a3.tgl_berlaku AND a1.kode_produk=a3.kode_produk AND a1.kode_cabang = a3.kode_cabang) t1
GROUP BY t1.bulan_transaksi, t1.nama_cabang ORDER BY t1.nama_cabang) y1 ;

ii.	Perkota
SELECT y1.bulan_transaksi bulan_transaksi, y1.nama_kota nama_kota, 
y1.jumlah_pembelian, SUM(y1.jumlah_pembelian) OVER (PARTITION BY y1.nama_kota ORDER BY y1.seqnum) YTD_pembelian,
y1.amount, y1.profit
FROM 
(SELECT t1.bulan_transaksi bulan_transaksi , t1.nama_kota , SUM(t1.jumlah_pembelian) jumlah_pembelian ,
ROW_NUMBER() OVER (PARTITION BY t1.nama_kota ORDER BY t1.nama_kota, t1.bulan_transaksi) seqnum,
SUM(t1.amount) amount , SUM(t1.profit) profit
FROM
(SELECT EXTRACT (MONTH FROM a1.tgl_transaksi) bulan_transaksi, a4.nama_kota nama_kota, a1.jumlah_pembelian jumlah_pembelian,
(a1.jumlah_pembelian*a3.harga_berlaku_cabang) amount,
((a1.jumlah_pembelian*a3.harga_berlaku_cabang)-(a1.jumlah_pembelian*(a3.biaya_cabang+a3.modal_cabang))) profit
FROM tr_penjualan a1
INNER JOIN ms_cabang a2 ON a1.kode_cabang=a2.kode_cabang
INNER JOIN ms_kota a4 ON a4.kode_kota = a2.kode_kota 
INNER JOIN ms_harga_harian a3 ON a1.tgl_transaksi=a3.tgl_berlaku AND a1.kode_produk=a3.kode_produk AND a1.kode_cabang = a3.kode_cabang) t1
GROUP BY t1.bulan_transaksi, t1.nama_kota ORDER BY t1.nama_kota) y1 ;

iii.	Perpropinsi
SELECT y1.bulan_transaksi bulan_transaksi, y1.nama_propinsi, 
y1.jumlah_pembelian, SUM(y1.jumlah_pembelian) OVER (PARTITION BY y1.nama_propinsi ORDER BY y1.seqnum) YTD_pembelian,
y1.amount, y1.profit
FROM 
(SELECT t1.bulan_transaksi bulan_transaksi , t1.nama_propinsi nama_propinsi , SUM(t1.jumlah_pembelian) jumlah_pembelian ,
ROW_NUMBER() OVER (PARTITION BY t1.nama_propinsi ORDER BY t1.nama_propinsi, t1.bulan_transaksi) seqnum,
SUM(t1.amount) amount , SUM(t1.profit) profit
FROM
(SELECT EXTRACT (MONTH FROM a1.tgl_transaksi) bulan_transaksi, a5.nama_propinsi nama_propinsi, a1.jumlah_pembelian jumlah_pembelian,
(a1.jumlah_pembelian*a3.harga_berlaku_cabang) amount,
((a1.jumlah_pembelian*a3.harga_berlaku_cabang)-(a1.jumlah_pembelian*(a3.biaya_cabang+a3.modal_cabang))) profit
FROM tr_penjualan a1
INNER JOIN ms_cabang a2 ON a1.kode_cabang=a2.kode_cabang
INNER JOIN ms_kota a4 ON a4.kode_kota = a2.kode_kota 
INNER JOIN ms_propinsi a5 ON a4.kode_propinsi = a5.kode_propinsi 
INNER JOIN ms_harga_harian a3 ON a1.tgl_transaksi=a3.tgl_berlaku AND a1.kode_produk=a3.kode_produk AND a1.kode_cabang = a3.kode_cabang) t1
GROUP BY t1.bulan_transaksi, t1.nama_propinsi ORDER BY t1.nama_propinsi) y1 ;

iv.	Perproduk
SELECT y1.bulan_transaksi bulan_transaksi, y1.nama_produk, 
y1.jumlah_pembelian, SUM(y1.jumlah_pembelian) OVER (PARTITION BY y1.nama_produk ORDER BY y1.seqnum) YTD_pembelian,
y1.amount, y1.profit
FROM 
(SELECT t1.bulan_transaksi bulan_transaksi , t1.nama_produk nama_produk , SUM(t1.jumlah_pembelian) jumlah_pembelian ,
ROW_NUMBER() OVER (PARTITION BY t1.nama_produk ORDER BY t1.nama_produk, t1.bulan_transaksi) seqnum,
SUM(t1.amount) amount , SUM(t1.profit) profit
FROM
(SELECT EXTRACT (MONTH FROM a1.tgl_transaksi) bulan_transaksi, a2.nama_produk nama_produk, a1.jumlah_pembelian jumlah_pembelian,
(a1.jumlah_pembelian*a3.harga_berlaku_cabang) amount,
((a1.jumlah_pembelian*a3.harga_berlaku_cabang)-(a1.jumlah_pembelian*(a3.biaya_cabang+a3.modal_cabang))) profit
FROM tr_penjualan a1
INNER JOIN ms_produk a2 ON a2.kode_produk =a1.kode_produk 
INNER JOIN ms_harga_harian a3 ON a1.tgl_transaksi=a3.tgl_berlaku AND a1.kode_produk=a3.kode_produk AND a1.kode_cabang = a3.kode_cabang) t1
GROUP BY t1.bulan_transaksi, t1.nama_produk ORDER BY t1.nama_produk) y1 ;

e.	Top 3 penjualan terbaik
i.	Total profit pada nama cabang per kota perbulan
SELECT c1.seqnum top_rank, c1.bulan_transaksi, c1.nama_kota, c1.nama_cabang, c1.jumlah_pembelian, c1.amount, c1.profit
FROM
(SELECT b1.bulan_transaksi bulan_transaksi , b1.nama_kota nama_kota , b1.nama_cabang nama_cabang , b1.jumlah_pembelian jumlah_pembelian ,
b1.amount amount, b1.profit profit,
RANK () OVER (PARTITION BY b1.bulan_transaksi, b1.nama_kota ORDER BY b1.bulan_transaksi, b1.profit DESC) seqnum
FROM
(SELECT t1.bulan_transaksi bulan_transaksi , t1.nama_kota nama_kota, t1.nama_cabang nama_cabang , 
SUM(t1.jumlah_pembelian) jumlah_pembelian , SUM(t1.amount) amount , SUM(t1.profit) profit
 FROM 
 (SELECT EXTRACT (MONTH FROM a1.tgl_transaksi) bulan_transaksi, a5.nama_kota nama_kota, a4.nama_cabang nama_cabang, a1.jumlah_pembelian jumlah_pembelian, 
 (a1.jumlah_pembelian* a3.harga_berlaku_cabang) amount, 
 ((a1.jumlah_pembelian*a3.harga_berlaku_cabang)-(a1.jumlah_pembelian*(a3.biaya_cabang+a3.modal_cabang))) profit 
 FROM tr_penjualan a1 INNER JOIN ms_harga_harian a3 
 ON a1.tgl_transaksi=a3.tgl_berlaku AND a1.kode_produk =a3.kode_produk AND a1.kode_cabang = a3.kode_cabang INNER JOIN ms_cabang a4 ON
 a4.kode_cabang= a1.kode_cabang INNER JOIN ms_kota a5 ON a5.kode_kota= a4.kode_kota) t1 
 GROUP BY t1.bulan_transaksi, t1.nama_kota, t1.nama_cabang ORDER BY t1.bulan_transaksi, t1.nama_cabang) b1) c1 
ORDER BY c1.bulan_transaksi, c1.seqnum, c1.nama_kota;

ii.	Total profit pada nama cabang per propinsi perbulan
SELECT c1.seqnum top_rank, c1.bulan_transaksi, c1.nama_propinsi, c1.nama_cabang, c1.jumlah_pembelian, c1.amount, c1.profit
FROM
(SELECT b1.bulan_transaksi bulan_transaksi , b1.nama_propinsi nama_propinsi, b1.nama_cabang nama_cabang , b1.jumlah_pembelian jumlah_pembelian ,
b1.amount amount, b1.profit profit,
RANK () OVER (PARTITION BY b1.bulan_transaksi, b1.nama_propinsi ORDER BY b1.bulan_transaksi, b1.profit DESC) seqnum
FROM
(SELECT t1.bulan_transaksi bulan_transaksi , t1.nama_propinsi nama_propinsi, t1.nama_cabang nama_cabang , 
SUM(t1.jumlah_pembelian) jumlah_pembelian , SUM(t1.amount) amount , SUM(t1.profit) profit
 FROM 
 (SELECT EXTRACT (MONTH FROM a1.tgl_transaksi) bulan_transaksi, a6.nama_propinsi nama_propinsi , a4.nama_cabang nama_cabang, a1.jumlah_pembelian jumlah_pembelian, 
 (a1.jumlah_pembelian* a3.harga_berlaku_cabang) amount, 
 ((a1.jumlah_pembelian*a3.harga_berlaku_cabang)-(a1.jumlah_pembelian*(a3.biaya_cabang+a3.modal_cabang))) profit 
 FROM tr_penjualan a1 INNER JOIN ms_harga_harian a3 
 ON a1.tgl_transaksi=a3.tgl_berlaku AND a1.kode_produk =a3.kode_produk AND a1.kode_cabang = a3.kode_cabang INNER JOIN ms_cabang a4 ON
 a4.kode_cabang= a1.kode_cabang INNER JOIN ms_kota a5 ON a5.kode_kota= a4.kode_kota INNER JOIN ms_propinsi a6 ON a6.kode_propinsi = a5.kode_propinsi) t1 
 GROUP BY t1.bulan_transaksi, t1.nama_propinsi, t1.nama_cabang ORDER BY t1.bulan_transaksi, t1.nama_cabang) b1) c1 
ORDER BY c1.bulan_transaksi, c1.seqnum, c1.nama_propinsi;

iii.	Total profit pada nama produk per kota perbulan
SELECT c1.seqnum top_rank, c1.bulan_transaksi, c1.nama_kota, c1.nama_produk, c1.jumlah_pembelian, c1.amount, c1.profit
FROM
(SELECT b1.bulan_transaksi bulan_transaksi , b1.nama_kota nama_kota, b1.nama_produk nama_produk , 
b1.jumlah_pembelian jumlah_pembelian , b1.amount amount, b1.profit profit,
RANK () OVER (PARTITION BY b1.bulan_transaksi, b1.nama_kota ORDER BY b1.bulan_transaksi, b1.profit DESC) seqnum
FROM
(SELECT t1.bulan_transaksi bulan_transaksi , t1.nama_kota nama_kota, t1.nama_produk nama_produk , 
SUM(t1.jumlah_pembelian) jumlah_pembelian , SUM(t1.amount) amount , SUM(t1.profit) profit
 FROM 
 (SELECT EXTRACT (MONTH FROM a1.tgl_transaksi) bulan_transaksi, a5.nama_kota nama_kota, a2.nama_produk nama_produk,
  a1.jumlah_pembelian jumlah_pembelian, 
 (a1.jumlah_pembelian* a3.harga_berlaku_cabang) amount, 
 ((a1.jumlah_pembelian*a3.harga_berlaku_cabang)-(a1.jumlah_pembelian*(a3.biaya_cabang+a3.modal_cabang))) profit 
 FROM tr_penjualan a1 INNER JOIN ms_produk a2 ON a2.kode_produk = a1.kode_produk  INNER JOIN ms_harga_harian a3 
 ON a1.tgl_transaksi=a3.tgl_berlaku AND a1.kode_produk =a3.kode_produk AND a1.kode_cabang = a3.kode_cabang INNER JOIN ms_cabang a4 ON
 a4.kode_cabang= a1.kode_cabang INNER JOIN ms_kota a5 ON a5.kode_kota= a4.kode_kota) t1 
 GROUP BY t1.bulan_transaksi, t1.nama_kota, t1.nama_produk ORDER BY t1.bulan_transaksi, t1.nama_produk) b1) c1
  ORDER BY c1.bulan_transaksi, c1.seqnum, c1.nama_kota;
  
iv.	Total profit pada nama produk per propinsi perbulan
SELECT c1.seqnum top_rank, c1.bulan_transaksi, c1.nama_propinsi, c1.nama_produk, c1.jumlah_pembelian, c1.amount, c1.profit
FROM
(SELECT b1.bulan_transaksi bulan_transaksi , b1.nama_propinsi nama_propinsi, b1.nama_produk nama_produk , b1.jumlah_pembelian jumlah_pembelian ,
b1.amount amount, b1.profit profit,
RANK () OVER (PARTITION BY b1.bulan_transaksi, b1.nama_propinsi ORDER BY b1.bulan_transaksi, b1.profit DESC) seqnum
FROM
(SELECT t1.bulan_transaksi bulan_transaksi , t1.nama_propinsi nama_propinsi, t1.nama_produk nama_produk , 
SUM(t1.jumlah_pembelian) jumlah_pembelian , SUM(t1.amount) amount , SUM(t1.profit) profit
 FROM 
 (SELECT EXTRACT (MONTH FROM a1.tgl_transaksi) bulan_transaksi, a6.nama_propinsi nama_propinsi , a2.nama_produk nama_produk, a1.jumlah_pembelian jumlah_pembelian, 
 (a1.jumlah_pembelian* a3.harga_berlaku_cabang) amount, 
 ((a1.jumlah_pembelian*a3.harga_berlaku_cabang)-(a1.jumlah_pembelian*(a3.biaya_cabang+a3.modal_cabang))) profit 
 FROM tr_penjualan a1 INNER JOIN ms_produk a2 ON a2.kode_produk = a1.kode_produk  INNER JOIN ms_harga_harian a3 
 ON a1.tgl_transaksi=a3.tgl_berlaku AND a1.kode_produk =a3.kode_produk AND a1.kode_cabang = a3.kode_cabang INNER JOIN ms_cabang a4 ON
 a4.kode_cabang= a1.kode_cabang INNER JOIN ms_kota a5 ON a5.kode_kota= a4.kode_kota INNER JOIN ms_propinsi a6 ON a6.kode_propinsi = a5.kode_propinsi) t1 
 GROUP BY t1.bulan_transaksi, t1.nama_propinsi, t1.nama_produk ORDER BY t1.bulan_transaksi, t1.nama_produk) b1) c1 
ORDER BY c1.bulan_transaksi, c1.seqnum, c1.nama_propinsi;
  
f.	Perbandingan dengan bulan sebelumnya
i.	Total profit dan growth pada nama cabang per kota setiap bulan
SELECT z1.bulan_transaksi, z1.nama_kota, z1.nama_cabang, z1.jumlah_pembelian, z1.amount, z1.profit, z1.profit_bulan_lalu, selisih,
CAST(z1.selisih AS DECIMAL)/z1.profit persentase
FROM
(SELECT y1.bulan_transaksi bulan_transaksi , y1.nama_kota nama_kota , y1.nama_cabang nama_cabang , y1.jumlah_pembelian jumlah_pembelian , 
y1.amount amount, y1.profit profit, y1.profit_bulan_lalu profit_bulan_lalu,
(y1.profit-y1.profit_bulan_lalu) selisih
FROM
(SELECT x1.bulan_transaksi bulan_transaksi , x1.nama_kota nama_kota , x1.nama_cabang nama_cabang , x1.jumlah_pembelian jumlah_pembelian ,
x1.amount amount, x1.profit profit,
LAG(x1.profit,3) OVER (ORDER BY x1.bulan_transaksi, x1.nama_cabang) profit_bulan_lalu
FROM
(SELECT t1.bulan_transaksi bulan_transaksi , t1.nama_kota, t1.nama_cabang nama_cabang , 
SUM(t1.jumlah_pembelian) jumlah_pembelian , SUM(t1.amount) amount , SUM(t1.profit) profit
FROM
(SELECT EXTRACT (MONTH FROM a1.tgl_transaksi) bulan_transaksi, a4.nama_kota nama_kota, a2.nama_cabang nama_cabang,
a1.jumlah_pembelian jumlah_pembelian,
(a1.jumlah_pembelian*a3.harga_berlaku_cabang) amount,
((a1.jumlah_pembelian*a3.harga_berlaku_cabang)-(a1.jumlah_pembelian*(a3.biaya_cabang+a3.modal_cabang))) profit
FROM tr_penjualan a1
INNER JOIN ms_cabang a2 ON a1.kode_cabang=a2.kode_cabang
INNER JOIN ms_kota a4 ON a4.kode_kota = a2.kode_kota 
INNER JOIN ms_harga_harian a3 ON a1.tgl_transaksi=a3.tgl_berlaku AND a1.kode_produk=a3.kode_produk AND a1.kode_cabang = a3.kode_cabang) t1
GROUP BY t1.bulan_transaksi, t1.nama_cabang, t1.nama_kota ORDER BY t1.nama_cabang) x1 ORDER BY x1.bulan_transaksi, x1.nama_cabang) y1) z1
ORDER BY z1.nama_kota;

ii.	Total profit dan growth pada nama produk per kota setiap bulan
SELECT z1.bulan_transaksi, z1.nama_kota, z1.jumlah_pembelian, z1.amount, z1.profit, z1.profit_bulan_lalu, selisih,
CAST(z1.selisih AS DECIMAL)/z1.profit persentase
FROM
(SELECT y1.bulan_transaksi bulan_transaksi , y1.nama_kota nama_kota , y1.jumlah_pembelian jumlah_pembelian , 
y1.amount amount, y1.profit profit, y1.profit_bulan_lalu profit_bulan_lalu,
(y1.profit-y1.profit_bulan_lalu) selisih
FROM
(SELECT x1.bulan_transaksi bulan_transaksi , x1.nama_kota nama_kota , x1.jumlah_pembelian jumlah_pembelian ,
x1.amount amount, x1.profit profit,
LAG(x1.profit,3) OVER (ORDER BY x1.bulan_transaksi, x1.nama_kota) profit_bulan_lalu
FROM
(SELECT t1.bulan_transaksi bulan_transaksi , t1.nama_kota,
SUM(t1.jumlah_pembelian) jumlah_pembelian , SUM(t1.amount) amount , SUM(t1.profit) profit
FROM
(SELECT EXTRACT (MONTH FROM a1.tgl_transaksi) bulan_transaksi, a4.nama_kota nama_kota,
a1.jumlah_pembelian jumlah_pembelian,
(a1.jumlah_pembelian*a3.harga_berlaku_cabang) amount,
((a1.jumlah_pembelian*a3.harga_berlaku_cabang)-(a1.jumlah_pembelian*(a3.biaya_cabang+a3.modal_cabang))) profit
FROM tr_penjualan a1
INNER JOIN ms_cabang a2 ON a1.kode_cabang=a2.kode_cabang
INNER JOIN ms_kota a4 ON a4.kode_kota = a2.kode_kota 
INNER JOIN ms_harga_harian a3 ON a1.tgl_transaksi=a3.tgl_berlaku AND a1.kode_produk=a3.kode_produk AND a1.kode_cabang = a3.kode_cabang) t1
GROUP BY t1.bulan_transaksi, t1.nama_kota ORDER BY t1.nama_kota) x1 ORDER BY x1.bulan_transaksi, x1.nama_kota) y1) z1
ORDER BY z1.nama_kota;
 
 g.	Total profit dan growth pada nama cabang per kota setiap bulan disertai dengan keterangan naik turun dari growth rate
SELECT b1.bulan_transaksi, b1.nama_kota, b1.nama_cabang, b1.jumlah_pembelian,
SUM(b1.jumlah_pembelian) OVER (PARTITION BY b1.nama_kota ORDER BY b1.seqnum) YTD_pembelian,
b1.profit, b1.profit_bulan_lalu, b1.persentase,
CASE WHEN (b1.persentase IS NULL) THEN 'Tidak ada penjualan'
 WHEN (b1.persentase>0) THEN CONCAT('Naik sebesar Rp. ',b1.selisih)
 WHEN (b1.persentase<0) THEN CONCAT('Turun sebear Rp. ',b1.selisih*-1)
 WHEN (b1.persentase=0) THEN 'Tidak berubah'
END AS status_penjualan
FROM
(SELECT z1.bulan_transaksi bulan_transaksi , z1.nama_kota nama_kota , z1.nama_cabang nama_cabang , z1.jumlah_pembelian jumlah_pembelian , 
z1.amount amount, z1.profit profit, z1.profit_bulan_lalu profit_bulan_lalu, selisih,
CAST(z1.selisih AS DECIMAL)/z1.profit persentase, ROW_NUMBER() OVER (PARTITION BY z1.nama_kota ORDER BY z1.nama_kota, z1.bulan_transaksi) seqnum
FROM
(SELECT y1.bulan_transaksi bulan_transaksi , y1.nama_kota nama_kota , y1.nama_cabang nama_cabang , y1.jumlah_pembelian jumlah_pembelian , 
y1.amount amount, y1.profit profit, y1.profit_bulan_lalu profit_bulan_lalu,
(y1.profit-y1.profit_bulan_lalu) selisih
FROM
(SELECT x1.bulan_transaksi bulan_transaksi , x1.nama_kota nama_kota , x1.nama_cabang nama_cabang , x1.jumlah_pembelian jumlah_pembelian ,
x1.amount amount, x1.profit profit,
LAG(x1.profit,3) OVER (ORDER BY x1.bulan_transaksi, x1.nama_cabang) profit_bulan_lalu
FROM
(SELECT t1.bulan_transaksi bulan_transaksi , t1.nama_kota, t1.nama_cabang nama_cabang , 
SUM(t1.jumlah_pembelian) jumlah_pembelian , SUM(t1.amount) amount , SUM(t1.profit) profit
FROM
(SELECT EXTRACT (MONTH FROM a1.tgl_transaksi) bulan_transaksi, a4.nama_kota nama_kota, a2.nama_cabang nama_cabang,
a1.jumlah_pembelian jumlah_pembelian,
(a1.jumlah_pembelian*a3.harga_berlaku_cabang) amount,
((a1.jumlah_pembelian*a3.harga_berlaku_cabang)-(a1.jumlah_pembelian*(a3.biaya_cabang+a3.modal_cabang))) profit
FROM tr_penjualan a1
INNER JOIN ms_cabang a2 ON a1.kode_cabang=a2.kode_cabang
INNER JOIN ms_kota a4 ON a4.kode_kota = a2.kode_kota 
INNER JOIN ms_harga_harian a3 ON a1.tgl_transaksi=a3.tgl_berlaku AND a1.kode_produk=a3.kode_produk AND a1.kode_cabang = a3.kode_cabang) t1
GROUP BY t1.bulan_transaksi, t1.nama_cabang, t1.nama_kota ORDER BY t1.nama_cabang) x1 ORDER BY x1.bulan_transaksi, x1.nama_cabang) y1) z1
ORDER BY z1.nama_kota) b1 ORDER BY b1.nama_kota;