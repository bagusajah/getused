#!/usr/bin/python

from prometheus_client import start_http_server, Gauge
from threading import Thread
import psycopg2, pymysql.cursors, time, sys, logging, time, requests

remit_total = Gauge('remit_daily_total', 'Total transaksi hari ini')
remit_sukses = Gauge('remit_daily_sukses', 'Total transaksi sukses hari ini')
remit_gagal = Gauge('remit_daily_gagal', 'Total transaksi gagal hari ini')

trx_total = Gauge('trx_daily_total', 'Total transaksi hari ini')
trx_sukses = Gauge('trx_daily_sukses', 'Total transaksi sukses hari ini')
trx_gagal = Gauge('trx_daily_gagal', 'Total transaksi gagal hari ini')
trx_pending = Gauge('trx_daily_pending', 'Total transaksi pending hari ini')
trx_open = Gauge('trx_daily_open', 'Total transaksi open hari ini')

trx_gagal_top_10 = Gauge('trx_daily_gagal_top_10', 'Top 10 transaksi gagal hari ini', ['NamaSupplier','NamaTipeTransaksi','NamaOperator','Nominal','StatusTRX'])
daily_pending = Gauge('daily_not_success', 'Pending', ['NamaSupplier','NamaTipeTransaksi','NamaOperator','Nominal2'])

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def pg_connection(nama_fungsi):
	#Deklarasi variable pg_conn agar bisa di akses fungsi lain
	global pg_conn
	nama_fungsi = nama_fungsi

	try:
       		pg_conn = psycopg2.connect(database="TMN", user="grafana", password="kjw#JHE382c", host="172.16.80.102", port="5432")
       		logger.info(time.ctime() + ' -> Functions ' + nama_fungsi + ' success connect to database...')
	except:
       		logger.error(time.ctime() + ' -> Failed connect to database...')
		sys.exit()

def my_connection(fungsi):
    global my_conn
    fungsi = fungsi

    try:
           my_conn = pymysql.connect(host='172.16.80.126', user='grafana', password='kjw#JHE382c', db='mw_remittance', cursorclass=pymysql.cursors.DictCursor)
           logger.info(time.ctime() + ' -> Functions ' + fungsi + ' success connect to database...')
    except:
         logger.error(time.ctime() + ' -> Failed connect to database...')
         sys.exit()

def	daily_remit_trx():
    total = sukses = gagal = 0
    fungsi = 'daily_remit'

    my_connection(fungsi)
    my_cur = my_conn.cursor()
    my_cur.execute("SELECT STATUS, COUNT(*) FROM MTCN_TRANSACTION_DETAILS WHERE(1=1) AND MTCN_TRANSACTION_DETAILS.TYPE=1 AND DATE(CREATED_DATE) = CURDATE() GROUP BY STATUS")

    rows = my_cur.fetchall()

    for data in rows:
        if data['STATUS'] == 0:
           sukses = data['COUNT(*)']
        if data['STATUS'] != 0:
           gagal = data['COUNT(*)']

    total = sukses + gagal
    remit_total.set(total)
    remit_sukses.set(sukses)
    remit_gagal.set(gagal)

def daily_mon_trx():
	total = sukses = gagal = pending = open = 0
	nama_fungsi = 'daily_mon_trx'

	pg_connection(nama_fungsi)
	pg_cur = pg_conn.cursor()
	pg_cur.execute("SELECT \"StatusTRX\",\"count\"(*) FROM \"TrTransaksi\" WHERE \"TimeStamp\"::DATE = now()::DATE GROUP BY \"StatusTRX\";")

	rows = pg_cur.fetchall()

	for data in rows:
		if data[0] == 'SUKSES':
			sukses = data[1]
		if data[0] == 'GAGAL':
			gagal = data[1]
		if data[0] == 'PENDING':
			pending = data[1]
		if data[0] == 'OPEN':
			open = data[1]

	# Total transaksi
	total = sukses + gagal + pending + open

	# Set ke trx exporter
	trx_total.set(total)
	trx_sukses.set(sukses)
	trx_gagal.set(gagal)
	trx_pending.set(pending)
	trx_open.set(open)

def daily_top10_failed():
    nama_fungsi = 'daily_top10_failed'
    hour = time.strftime("%H")

    if hour == "01":
            # Flush metrics trx_gagal_top_10
            requests.delete("http://prometheus:9090/api/v1/series?match[]=trx_daily_gagal_top_10")
            requests.delete("http://prometheus:9090/api/v1/series?match[]=saldo_bimasakti")
    else:
            pass

    pg_connection(nama_fungsi)
    pg_cur = pg_conn.cursor()
    pg_cur.execute("SELECT \"NamaSupplier\", \"NamaTipeTransaksi\", \"NamaOperator\", \"MsDenom\".\"Nominal\", \"StatusTRX\", \"count\"(*) FROM \"TrTransaksi\" LEFT JOIN \"MsDenom\" ON \"MsDenom\".id_denom = \"TrTransaksi\".id_denom LEFT JOIN \"MsOperator\" ON \"MsOperator\".id_operator = \"TrTransaksi\".id_operator,\"MsSupplier\",\"MsTipeTransaksi\" WHERE \"TrTransaksi\".id_supplier = \"MsSupplier\".id_supplier AND \"TrTransaksi\".id_tipetransaksi = \"MsTipeTransaksi\".id_tipetransaksi AND \"TrTransaksi\".\"TimeStamp\" :: DATE = now() :: DATE AND \"StatusTRX\" != \'SUKSES\' GROUP BY \"NamaSupplier\",\"NamaTipeTransaksi\",\"NamaOperator\",\"MsDenom\".\"Nominal\",\"StatusTRX\" ORDER BY COUNT DESC LIMIT 10")

    rows = pg_cur.fetchall()

    # Set value top 10 failed
    trx_gagal_top_10.labels(rows[0][0],rows[0][1],rows[0][2],rows[0][3],rows[0][4]).set(rows[0][5])
    trx_gagal_top_10.labels(rows[1][0],rows[1][1],rows[1][2],rows[1][3],rows[1][4]).set(rows[1][5])
    trx_gagal_top_10.labels(rows[2][0],rows[2][1],rows[2][2],rows[2][3],rows[2][4]).set(rows[2][5])
    trx_gagal_top_10.labels(rows[3][0],rows[3][1],rows[3][2],rows[3][3],rows[3][4]).set(rows[3][5])
    trx_gagal_top_10.labels(rows[4][0],rows[4][1],rows[4][2],rows[4][3],rows[4][4]).set(rows[4][5])
    trx_gagal_top_10.labels(rows[5][0],rows[5][1],rows[5][2],rows[5][3],rows[5][4]).set(rows[5][5])
    trx_gagal_top_10.labels(rows[6][0],rows[6][1],rows[6][2],rows[6][3],rows[6][4]).set(rows[6][5])
    trx_gagal_top_10.labels(rows[7][0],rows[7][1],rows[7][2],rows[7][3],rows[7][4]).set(rows[7][5])
    trx_gagal_top_10.labels(rows[8][0],rows[8][1],rows[8][2],rows[8][3],rows[8][4]).set(rows[8][5])
    trx_gagal_top_10.labels(rows[9][0],rows[9][1],rows[9][2],rows[9][3],rows[9][4]).set(rows[9][5])

def daily_not_success():
    nama_fungsi = 'daily_not_success'
    hour = time.strftime("%H")

    if hour == "01":
            # Flush metrics
            requests.delete("http://prometheus:9090/api/v1/series?match[]=daily_not_success")
    else:
            pass

    pg_connection(nama_fungsi)
    pg_cur = pg_conn.cursor()
    #pg_cur.execute("SELECT B.\"NamaSupplier\", A.* FROM \"TrTransaksi\" A JOIN \"MsSupplier\" B ON A.id_supplier = B.id_supplier WHERE \"StatusTRX\" IN ('PENDING','NOK') and A.\"TimeStamp\" ::DATE = now()::DATE ORDER BY \"TimeStamp\";")
    pg_cur.execute("SELECT \"NamaSupplier\", \"NamaTipeTransaksi\", \"NamaOperator\", \"MsDenom\".\"Nominal\", \"StatusTRX\" FROM \"TrTransaksi\" LEFT JOIN \"MsDenom\" ON \"MsDenom\".id_denom = \"TrTransaksi\".id_denom LEFT JOIN \"MsOperator\" ON \"MsOperator\".id_operator = \"TrTransaksi\".id_operator,\"MsSupplier\",\"MsTipeTransaksi\" WHERE \"TrTransaksi\".id_supplier = \"MsSupplier\".id_supplier AND \"TrTransaksi\".id_tipetransaksi = \"MsTipeTransaksi\".id_tipetransaksi AND \"TrTransaksi\".\"TimeStamp\" :: DATE = now() :: DATE AND \"StatusTRX\" = 'PENDING' GROUP BY \"NamaSupplier\",\"NamaTipeTransaksi\",\"NamaOperator\",\"MsDenom\".\"Nominal\",\"StatusTRX\", \"TrTransaksi\".\"TimeStamp\" ORDER BY \"TrTransaksi\".\"TimeStamp\" DESC LIMIT 10;")

    rows = pg_cur.fetchone()

    daily_pending.labels(rows[0][0],rows[0][1],rows[0][2],rows[0][3]).set(rows[0][5])

if __name__ == '__main__':

    start_http_server(9982)

    while True:
         try:
             daily_mon_remit_thread = Thread(target=daily_remit_trx)
             daily_mon_trx_thread = Thread(target=daily_mon_trx)
             daily_top10_failed_thread = Thread(target=daily_top10_failed)
             daily_not_success_thread = Thread(target=daily_not_success)
             daily_mon_remit_thread.start()
             daily_mon_trx_thread.start()
             daily_top10_failed_thread.start()
             daily_not_success_thread.start()
             time.sleep(300)

         except KeyboardInterrupt:
             logger.info(time.ctime() + ' -> Trx exporter was stop...')
             sys.exit()

    conn.close()
