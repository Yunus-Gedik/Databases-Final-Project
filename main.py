# Python 3.7.0
# PyQt5 5.15.4

from PyQt5 import QtCore, QtGui, QtWidgets
import pyodbc
import pandas as pd
import sys

class Ui_a(object):

    def connect_db(self,conn_string):
        self.__conn = pyodbc.connect('Driver={SQL Server};'
                                     'Server=.\sqlexpress;'
                                     'Database=build_pc;'
                                     'Trusted_Connection=yes;')

    def build_clicked(self):
        # Get field values
        price = self.money.value()
        seller_rating = self.seller_rating.value()
        brand_rating = self.brand_rating.value()
        product_rating = self.product_rating.value()
        warranty = self.warranty.value()
        purpose = self.purpose_dd.currentText()
        focus = self.focus_dd.currentText()

        self.success_label.setHidden(True)

        # Max part price relative rate
        max_rate = 0.6

        # Clear tables from old data
        self.ram_table.clear()
        self.ram_table.setColumnCount(0)
        self.disk_table.clear()
        self.disk_table.setColumnCount(0)
        self.cpu_table.clear()
        self.cpu_table.setColumnCount(0)
        self.gpu_table.clear()
        self.gpu_table.setColumnCount(0)
        self.mb_table.clear()
        self.mb_table.setColumnCount(0)
        self.monitor_table.clear()
        self.monitor_table.setColumnCount(0)
        self.psu_table.clear()
        self.psu_table.setColumnCount(0)
        self.case_table.clear()
        self.case_table.setColumnCount(0)


        # Call procedures
        query = "exec possible_rams @seller_rating = " + str(seller_rating) + ", @brand_rating = " + str(brand_rating) +", @ram_rating = "+ str(product_rating) + ", @price = "+ str(max_rate*price) +", @warranty = " +str(warranty)
        sql_ram = pd.read_sql_query(query, conn)
        if sql_ram.values.tolist().__len__() == 0:
            self.error_label.setHidden(False)
            return

        query = "exec possible_disks @seller_rating = " + str(seller_rating) + ", @brand_rating = " + str(brand_rating) +", @disk_rating = "+ str(product_rating) + ", @price = "+ str(max_rate*price) +", @warranty = " +str(warranty)
        sql_disk = pd.read_sql_query(query, conn)
        if sql_disk.values.tolist().__len__() == 0:
            self.error_label.setHidden(False)
            return

        query = "exec possible_cpus @seller_rating = " + str(seller_rating) + ", @brand_rating = " + str(brand_rating) +", @cpu_rating = "+ str(product_rating) + ", @price = "+ str(max_rate*price) +", @warranty = " +str(warranty)
        sql_cpu = pd.read_sql_query(query, conn)
        if sql_cpu.values.tolist().__len__() == 0:
            self.error_label.setHidden(False)
            return

        query = "exec possible_gpus @seller_rating = " + str(seller_rating) + ", @brand_rating = " + str(brand_rating) +", @gpu_rating = "+ str(product_rating) + ", @price = "+ str(max_rate*price) +", @warranty = " +str(warranty)
        sql_gpu = pd.read_sql_query(query, conn)
        if sql_gpu.values.tolist().__len__() == 0:
            self.error_label.setHidden(False)
            return

        query = "exec possible_motherboards @seller_rating = " + str(seller_rating) + ", @brand_rating = " + str(brand_rating) +", @mb_rating = "+ str(product_rating) + ", @price = "+ str(max_rate*price) +", @warranty = " +str(warranty)
        sql_motherboard = pd.read_sql_query(query, conn)
        if sql_motherboard.values.tolist().__len__() == 0:
            self.error_label.setHidden(False)
            return

        query = "exec possible_monitors @seller_rating = " + str(seller_rating) + ", @brand_rating = " + str(brand_rating) +", @monitor_rating = "+ str(product_rating) + ", @price = "+ str(max_rate*price) +", @warranty = " +str(warranty)
        sql_monitor = pd.read_sql_query(query, conn)
        if sql_monitor.values.tolist().__len__() == 0:
            self.error_label.setHidden(False)
            return

        query = "exec possible_psus @seller_rating = " + str(seller_rating) + ", @brand_rating = " + str(brand_rating) +", @psu_rating = "+ str(product_rating) + ", @price = "+ str(max_rate*price) +", @warranty = " +str(warranty)
        sql_psu = pd.read_sql_query(query, conn)
        if sql_psu.values.tolist().__len__() == 0:
            self.error_label.setHidden(False)
            return

        query = "exec possible_cases @seller_rating = " + str(seller_rating) + ", @brand_rating = " + str(brand_rating) +", @case_rating = "+ str(product_rating) + ", @price = "+ str(max_rate*price) +", @warranty = " +str(warranty)
        sql_case = pd.read_sql_query(query, conn)
        if sql_case.values.tolist().__len__() == 0:
            self.error_label.setHidden(False)
            return

        # Variables to iterate through sql query results
        ram_i = 0
        ram_iter = 0
        disk_i = 0
        disk_iter = 0
        cpu_i = 0
        cpu_iter = 0
        gpu_i = 0
        gpu_iter = 0
        psu_i = 0
        psu_iter = 0
        monitor_i = 0
        monitor_iter = 0
        motherboard_i = 0
        motherboard_iter = 0
        case_i = 0
        case_iter = 0

        # Focus and purpose fine tune
        cpu_loop = 1
        gpu_loop = 1
        monitor_loop = 1
        case_loop = 1
        if focus == "User Interaction":
            case_loop += 1
            monitor_loop += 1
        elif purpose == "Gaming":
            gpu_loop += 1
        elif purpose == "Working":
            cpu_loop += 1

        # Check if a computer buildable.
        current_price = 0
        current_price += min(sql_ram["price"])
        current_price += min(sql_disk["price"])
        current_price += min(sql_psu["price"])
        current_price += min(sql_cpu["price"])
        current_price += min(sql_gpu["price"])
        current_price += min(sql_monitor["price"])
        current_price += min(sql_motherboard["price"])
        current_price += min(sql_case["price"])

        if current_price > price:
            self.error_label.setHidden(False)
            return

        # Assign start price
        current_price = 0
        current_price += sql_ram.iloc[0]["price"]
        current_price += sql_disk.iloc[0]["price"]
        current_price += sql_psu.iloc[0]["price"]
        current_price += sql_cpu.iloc[0]["price"]
        current_price += sql_gpu.iloc[0]["price"]
        current_price += sql_monitor.iloc[0]["price"]
        current_price += sql_motherboard.iloc[0]["price"]
        current_price += sql_case.iloc[0]["price"]

        # Pick parts
        for m in range(max(sql_ram.shape[0], sql_disk.shape[0], sql_cpu.shape[0] / cpu_loop, sql_gpu.shape[0] / gpu_loop,
                           sql_case.shape[0] / case_loop, sql_motherboard.shape[0], sql_monitor.shape[0] / monitor_loop,
                           sql_psu.shape[0])):
            if sql_ram.shape[0] > ram_iter:
                next = sql_ram.iloc[ram_iter]["price"]
                current = sql_ram.iloc[ram_i]["price"]
                if next <= current:
                    ram_i = ram_iter
                    current_price -= current - next
                elif next - current + current_price <= price and sql_ram.iloc[ram_iter]["ramID"] != sql_ram.iloc[ram_i]["ramID"]:
                    ram_i = ram_iter
                    current_price += next - current
            ram_iter += 1

            if sql_disk.shape[0] > disk_iter:
                next = sql_disk.iloc[disk_iter]["price"]
                current = sql_disk.iloc[disk_i]["price"]
                if next <= current:
                    disk_i = disk_iter
                    current_price -= current - next
                elif next - current + current_price <= price and sql_disk.iloc[disk_iter]["diskID"] != sql_disk.iloc[disk_i]["diskID"]:
                    disk_i = disk_iter
                    current_price += next - current
            disk_iter += 1

            for i in range(cpu_loop):
                if sql_cpu.shape[0] > cpu_iter:
                    next = sql_cpu.iloc[cpu_iter]["price"]
                    current = sql_cpu.iloc[cpu_i]["price"]
                    if next <= current:
                        cpu_i = cpu_iter
                        current_price -= current - next
                    elif next - current + current_price <= price and sql_cpu.iloc[cpu_iter]["cpuID"] != sql_cpu.iloc[cpu_i]["cpuID"]:
                        cpu_i = cpu_iter
                        current_price += next - current
                cpu_iter += 1


            for i in range(gpu_loop):
                if sql_gpu.shape[0] > gpu_iter:
                    next = sql_gpu.iloc[gpu_iter]["price"]
                    current = sql_gpu.iloc[gpu_i]["price"]
                    if next <= current:
                        gpu_i = gpu_iter
                        current_price -= current - next
                    elif next - current + current_price <= price and sql_gpu.iloc[gpu_iter]["gpuID"] != sql_gpu.iloc[gpu_i]["gpuID"]:
                        gpu_i = gpu_iter
                        current_price += next - current
                gpu_iter += 1

            for i in range(case_loop):
                if sql_case.shape[0] > case_iter:
                    next = sql_case.iloc[case_iter]["price"]
                    current = sql_case.iloc[case_i]["price"]
                    if next <= current:
                        case_i = case_iter
                        current_price -= current - next
                    elif next - current + current_price <= price and sql_case.iloc[case_iter]["caseID"] != sql_case.iloc[case_i]["caseID"]:
                        case_i = case_iter
                        current_price += next - current
                case_iter += 1

            if sql_motherboard.shape[0] > motherboard_iter:
                next = sql_motherboard.iloc[motherboard_iter]["price"]
                current = sql_motherboard.iloc[motherboard_i]["price"]
                if next <= current:
                    motherboard_i = motherboard_iter
                    current_price -= current - next
                elif next - current + current_price <= price and sql_motherboard.iloc[motherboard_iter]["motherboardID"] != sql_motherboard.iloc[motherboard_i]["motherboardID"]:
                    motherboard_i = motherboard_iter
                    current_price += next - current
            motherboard_iter += 1

            for i in range(monitor_loop):
                if sql_monitor.shape[0] > monitor_iter:
                    next = sql_monitor.iloc[monitor_iter]["price"]
                    current = sql_monitor.iloc[monitor_i]["price"]
                    if next <= current:
                        monitor_i = monitor_iter
                        current_price -= current - next
                    elif next - current + current_price <= price and sql_monitor.iloc[monitor_iter]["monitorID"] != sql_monitor.iloc[monitor_i]["monitorID"]:
                        monitor_i = monitor_iter
                        current_price += next - current
                monitor_iter += 1

            if sql_psu.shape[0] > psu_iter:
                next = sql_psu.iloc[psu_iter]["price"]
                current = sql_psu.iloc[psu_i]["price"]
                if next <= current:
                    psu_i = psu_iter
                    current_price -= current - next
                elif next - current + current_price <= price and sql_psu.iloc[psu_iter]["psuID"] != sql_psu.iloc[psu_i]["psuID"]:
                    psu_i = psu_iter
                    current_price += next - current
            psu_iter += 1


        # Fill tables
        column_names = sql_ram.columns.tolist()
        self.ram_table.setColumnCount(column_names.__len__())
        self.ram_table.setHorizontalHeaderLabels(column_names)
        row = sql_ram.values.tolist()[ram_i]
        for i in range(len(row)):
            self.ram_table.setItem(0,i,QtWidgets.QTableWidgetItem(str(row[i])))

        column_names = sql_disk.columns.tolist()
        self.disk_table.setColumnCount(column_names.__len__())
        self.disk_table.setHorizontalHeaderLabels(column_names)
        row = sql_disk.values.tolist()[disk_i]
        for i in range(len(row)):
            self.disk_table.setItem(0,i,QtWidgets.QTableWidgetItem(str(row[i])))

        column_names = sql_cpu.columns.tolist()
        self.cpu_table.setColumnCount(column_names.__len__())
        self.cpu_table.setHorizontalHeaderLabels(column_names)
        row = sql_cpu.values.tolist()[cpu_i]
        for i in range(len(row)):
            self.cpu_table.setItem(0,i,QtWidgets.QTableWidgetItem(str(row[i])))

        column_names = sql_gpu.columns.tolist()
        self.gpu_table.setColumnCount(column_names.__len__())
        self.gpu_table.setHorizontalHeaderLabels(column_names)
        row = sql_gpu.values.tolist()[gpu_i]
        for i in range(len(row)):
            self.gpu_table.setItem(0,i,QtWidgets.QTableWidgetItem(str(row[i])))

        column_names = sql_motherboard.columns.tolist()
        self.mb_table.setColumnCount(column_names.__len__())
        self.mb_table.setHorizontalHeaderLabels(column_names)
        row = sql_motherboard.values.tolist()[motherboard_i]
        for i in range(len(row)):
            self.mb_table.setItem(0,i,QtWidgets.QTableWidgetItem(str(row[i])))

        column_names = sql_monitor.columns.tolist()
        self.monitor_table.setColumnCount(column_names.__len__())
        self.monitor_table.setHorizontalHeaderLabels(column_names)
        row = sql_monitor.values.tolist()[monitor_i]
        for i in range(len(row)):
            self.monitor_table.setItem(0,i,QtWidgets.QTableWidgetItem(str(row[i])))

        column_names = sql_psu.columns.tolist()
        self.psu_table.setColumnCount(column_names.__len__())
        self.psu_table.setHorizontalHeaderLabels(column_names)
        row = sql_psu.values.tolist()[psu_i]
        for i in range(len(row)):
            self.psu_table.setItem(0,i,QtWidgets.QTableWidgetItem(str(row[i])))

        column_names = sql_case.columns.tolist()
        self.case_table.setColumnCount(column_names.__len__())
        self.case_table.setHorizontalHeaderLabels(column_names)
        row = sql_case.values.tolist()[case_i]
        for i in range(len(row)):
            self.case_table.setItem(0,i,QtWidgets.QTableWidgetItem(str(row[i])))



        # Show Total Price and hide error label
        self.error_label.setHidden(True)
        self.success_label.setText("Total Price is " + str(sql_psu["price"].tolist()[psu_i] + sql_ram["price"].tolist()[ram_i] +
                                                       sql_disk["price"].tolist()[disk_i] + sql_case["price"].tolist()[case_i] +
                                                       sql_monitor["price"].tolist()[monitor_i] + sql_cpu["price"].tolist()[cpu_i]
                                                       + sql_gpu["price"].tolist()[gpu_i] + sql_motherboard["price"].tolist()[motherboard_i])
                                                       + "₺")
        self.success_label.setHidden(False)

    def view_dd_changed(self):
        text = self.view_dd.currentText()
        sql_q = ""

        if text == 'Ram':
            sql_q = pd.read_sql_query("select * from view_ram", conn)
        elif text == 'Disk':
            sql_q = pd.read_sql_query("select * from view_disk", conn)
        elif text == 'CPU':
            sql_q = pd.read_sql_query("select * from view_cpu", conn)
        elif text == 'GPU':
            sql_q = pd.read_sql_query("select * from view_gpu", conn)
        elif text == 'Motherboard':
            sql_q = pd.read_sql_query("select * from view_motherboard", conn)
        elif text == 'Monitor':
            sql_q = pd.read_sql_query("select * from view_monitor", conn)
        elif text == 'PSU':
            sql_q = pd.read_sql_query("select * from view_psu", conn)
        elif text == 'Case':
            sql_q = pd.read_sql_query("select * from view_case", conn)
        elif text == 'Seller':
            sql_q = pd.read_sql_query("exec get_sellers", conn)
        elif text == 'Brand':
            sql_q = pd.read_sql_query("exec get_brands", conn)

        self.view_table.clear()

        column_names = sql_q.columns.tolist()
        rows = sql_q.values.tolist()
        self.view_table.setColumnCount(column_names.__len__())
        self.view_table.setRowCount(rows.__len__())
        self.view_table.setHorizontalHeaderLabels(column_names)

        for i in range(len(rows)):
            for j in range(len(rows[i])):
                self.view_table.setItem(i,j,QtWidgets.QTableWidgetItem(str(rows[i][j])))

    def setupUi(self, a):
        a.setObjectName("a")
        a.resize(1077, 666)
        a.setMaximumSize(QtCore.QSize(1077, 666))
        self.centre = QtWidgets.QWidget(a)
        self.centre.setObjectName("centre")
        self.tabWidget = QtWidgets.QTabWidget(self.centre)
        self.tabWidget.setGeometry(QtCore.QRect(0, 0, 1071, 651))
        self.tabWidget.setObjectName("tabWidget")
        self.build = QtWidgets.QWidget()
        self.build.setObjectName("build")
        self.money = QtWidgets.QSpinBox(self.build)
        self.money.setGeometry(QtCore.QRect(20, 30, 81, 21))
        self.money.setMaximum(120000)
        self.money.setSingleStep(100)
        self.money.setProperty("value", 4000)
        self.money.setObjectName("money")
        self.label = QtWidgets.QLabel(self.build)
        self.label.setGeometry(QtCore.QRect(110, 30, 47, 13))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label.setFont(font)
        self.label.setObjectName("label")
        self.seller_rating = QtWidgets.QDoubleSpinBox(self.build)
        self.seller_rating.setGeometry(QtCore.QRect(20, 60, 62, 22))
        self.seller_rating.setDecimals(1)
        self.seller_rating.setMaximum(9.9)
        self.seller_rating.setSingleStep(0.1)
        self.seller_rating.setProperty("value", 7.0)
        self.seller_rating.setObjectName("seller_rating")
        self.label_2 = QtWidgets.QLabel(self.build)
        self.label_2.setGeometry(QtCore.QRect(90, 60, 151, 21))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.label_2.setFont(font)
        self.label_2.setObjectName("label_2")
        self.brand_rating = QtWidgets.QDoubleSpinBox(self.build)
        self.brand_rating.setGeometry(QtCore.QRect(20, 90, 62, 22))
        self.brand_rating.setDecimals(1)
        self.brand_rating.setMaximum(9.9)
        self.brand_rating.setSingleStep(0.1)
        self.brand_rating.setProperty("value", 7.0)
        self.brand_rating.setObjectName("brand_rating")
        self.label_3 = QtWidgets.QLabel(self.build)
        self.label_3.setGeometry(QtCore.QRect(90, 90, 151, 21))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.label_3.setFont(font)
        self.label_3.setObjectName("label_3")
        self.warranty = QtWidgets.QSpinBox(self.build)
        self.warranty.setGeometry(QtCore.QRect(20, 150, 51, 22))
        self.warranty.setMaximum(10)
        self.warranty.setProperty("value", 2)
        self.warranty.setObjectName("warranty")
        self.label_4 = QtWidgets.QLabel(self.build)
        self.label_4.setGeometry(QtCore.QRect(80, 150, 131, 16))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.label_4.setFont(font)
        self.label_4.setObjectName("label_4")
        self.purpose_dd = QtWidgets.QComboBox(self.build)
        self.purpose_dd.setGeometry(QtCore.QRect(20, 180, 71, 22))
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.purpose_dd.sizePolicy().hasHeightForWidth())
        self.purpose_dd.setSizePolicy(sizePolicy)
        self.purpose_dd.setEditable(False)
        self.purpose_dd.setObjectName("purpose_dd")
        self.purpose_dd.addItem("")
        self.purpose_dd.addItem("")
        self.label_5 = QtWidgets.QLabel(self.build)
        self.label_5.setGeometry(QtCore.QRect(100, 180, 101, 16))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.label_5.setFont(font)
        self.label_5.setObjectName("label_5")
        self.focus_dd = QtWidgets.QComboBox(self.build)
        self.focus_dd.setGeometry(QtCore.QRect(20, 210, 111, 22))
        self.focus_dd.setEditable(False)
        self.focus_dd.setObjectName("focus_dd")
        self.focus_dd.addItem("")
        self.focus_dd.addItem("")
        self.label_6 = QtWidgets.QLabel(self.build)
        self.label_6.setGeometry(QtCore.QRect(140, 210, 101, 16))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.label_6.setFont(font)
        self.label_6.setObjectName("label_6")
        self.bring = QtWidgets.QCommandLinkButton(self.build)
        self.bring.setGeometry(QtCore.QRect(20, 250, 211, 41))
        font = QtGui.QFont()
        font.setFamily("Segoe UI")
        font.setPointSize(13)
        font.setBold(False)
        font.setItalic(True)
        font.setUnderline(False)
        font.setWeight(50)
        font.setStrikeOut(False)
        self.bring.setFont(font)
        self.bring.setObjectName("bring")
        self.cpu_table = QtWidgets.QTableWidget(self.build)
        self.cpu_table.setGeometry(QtCore.QRect(385, 10, 671, 77))
        self.cpu_table.setObjectName("cpu_table")
        self.cpu_table.setColumnCount(0)
        self.cpu_table.setRowCount(0)
        self.gpu_table = QtWidgets.QTableWidget(self.build)
        self.gpu_table.setGeometry(QtCore.QRect(385, 86, 671, 77))
        self.gpu_table.setObjectName("gpu_table")
        self.gpu_table.setColumnCount(0)
        self.gpu_table.setRowCount(0)
        self.disk_table = QtWidgets.QTableWidget(self.build)
        self.disk_table.setGeometry(QtCore.QRect(385, 162, 671, 77))
        self.disk_table.setObjectName("disk_table")
        self.disk_table.setColumnCount(0)
        self.disk_table.setRowCount(0)
        self.ram_table = QtWidgets.QTableWidget(self.build)
        self.ram_table.setGeometry(QtCore.QRect(385, 238, 671, 77))
        self.ram_table.setObjectName("ram_table")
        self.ram_table.setColumnCount(0)
        self.ram_table.setRowCount(0)
        self.mb_table = QtWidgets.QTableWidget(self.build)
        self.mb_table.setGeometry(QtCore.QRect(385, 314, 671, 77))
        self.mb_table.setObjectName("mb_table")
        self.mb_table.setColumnCount(0)
        self.mb_table.setRowCount(0)
        self.psu_table = QtWidgets.QTableWidget(self.build)
        self.psu_table.setGeometry(QtCore.QRect(385, 542, 671, 77))
        self.psu_table.setObjectName("psu_table")
        self.psu_table.setColumnCount(0)
        self.psu_table.setRowCount(0)
        self.case_table = QtWidgets.QTableWidget(self.build)
        self.case_table.setGeometry(QtCore.QRect(385, 466, 671, 77))
        self.case_table.setObjectName("case_table")
        self.case_table.setColumnCount(0)
        self.case_table.setRowCount(0)
        self.monitor_table = QtWidgets.QTableWidget(self.build)
        self.monitor_table.setGeometry(QtCore.QRect(385, 390, 671, 77))
        self.monitor_table.setObjectName("monitor_table")
        self.monitor_table.setColumnCount(0)
        self.monitor_table.setRowCount(0)
        self.label_8 = QtWidgets.QLabel(self.build)
        self.label_8.setGeometry(QtCore.QRect(340, 41, 41, 20))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.label_8.setFont(font)
        self.label_8.setObjectName("label_8")
        self.label_9 = QtWidgets.QLabel(self.build)
        self.label_9.setGeometry(QtCore.QRect(340, 120, 41, 20))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.label_9.setFont(font)
        self.label_9.setObjectName("label_9")
        self.label_10 = QtWidgets.QLabel(self.build)
        self.label_10.setGeometry(QtCore.QRect(340, 190, 41, 20))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.label_10.setFont(font)
        self.label_10.setObjectName("label_10")
        self.label_11 = QtWidgets.QLabel(self.build)
        self.label_11.setGeometry(QtCore.QRect(340, 262, 41, 20))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.label_11.setFont(font)
        self.label_11.setObjectName("label_11")
        self.label_12 = QtWidgets.QLabel(self.build)
        self.label_12.setGeometry(QtCore.QRect(260, 335, 111, 20))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.label_12.setFont(font)
        self.label_12.setObjectName("label_12")
        self.label_13 = QtWidgets.QLabel(self.build)
        self.label_13.setGeometry(QtCore.QRect(300, 410, 81, 20))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.label_13.setFont(font)
        self.label_13.setObjectName("label_13")
        self.label_14 = QtWidgets.QLabel(self.build)
        self.label_14.setGeometry(QtCore.QRect(330, 489, 41, 20))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.label_14.setFont(font)
        self.label_14.setObjectName("label_14")
        self.label_15 = QtWidgets.QLabel(self.build)
        self.label_15.setGeometry(QtCore.QRect(340, 559, 41, 20))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.label_15.setFont(font)
        self.label_15.setObjectName("label_15")
        self.error_label = QtWidgets.QLabel(self.build)
        self.error_label.setGeometry(QtCore.QRect(24, 330, 211, 181))
        palette = QtGui.QPalette()
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.WindowText, brush)
        brush = QtGui.QBrush(QtGui.QColor(240, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Button, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 105, 105))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Light, brush)
        brush = QtGui.QBrush(QtGui.QColor(247, 52, 52))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Midlight, brush)
        brush = QtGui.QBrush(QtGui.QColor(120, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Dark, brush)
        brush = QtGui.QBrush(QtGui.QColor(160, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Mid, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Text, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 255, 255))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.BrightText, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.ButtonText, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 255, 255))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Base, brush)
        brush = QtGui.QBrush(QtGui.QColor(240, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Window, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Shadow, brush)
        brush = QtGui.QBrush(QtGui.QColor(247, 127, 127))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.AlternateBase, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 255, 220))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.ToolTipBase, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.ToolTipText, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0, 128))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.PlaceholderText, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.WindowText, brush)
        brush = QtGui.QBrush(QtGui.QColor(240, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Button, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 105, 105))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Light, brush)
        brush = QtGui.QBrush(QtGui.QColor(247, 52, 52))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Midlight, brush)
        brush = QtGui.QBrush(QtGui.QColor(120, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Dark, brush)
        brush = QtGui.QBrush(QtGui.QColor(160, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Mid, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Text, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 255, 255))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.BrightText, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.ButtonText, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 255, 255))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Base, brush)
        brush = QtGui.QBrush(QtGui.QColor(240, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Window, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Shadow, brush)
        brush = QtGui.QBrush(QtGui.QColor(247, 127, 127))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.AlternateBase, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 255, 220))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.ToolTipBase, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.ToolTipText, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0, 128))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.PlaceholderText, brush)
        brush = QtGui.QBrush(QtGui.QColor(120, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.WindowText, brush)
        brush = QtGui.QBrush(QtGui.QColor(240, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Button, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 105, 105))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Light, brush)
        brush = QtGui.QBrush(QtGui.QColor(247, 52, 52))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Midlight, brush)
        brush = QtGui.QBrush(QtGui.QColor(120, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Dark, brush)
        brush = QtGui.QBrush(QtGui.QColor(160, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Mid, brush)
        brush = QtGui.QBrush(QtGui.QColor(120, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Text, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 255, 255))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.BrightText, brush)
        brush = QtGui.QBrush(QtGui.QColor(120, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.ButtonText, brush)
        brush = QtGui.QBrush(QtGui.QColor(240, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Base, brush)
        brush = QtGui.QBrush(QtGui.QColor(240, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Window, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Shadow, brush)
        brush = QtGui.QBrush(QtGui.QColor(240, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.AlternateBase, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 255, 220))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.ToolTipBase, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.ToolTipText, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0, 128))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.PlaceholderText, brush)
        self.error_label.setPalette(palette)
        font = QtGui.QFont()
        font.setPointSize(24)
        self.error_label.setFont(font)
        self.error_label.setObjectName("error_label")
        self.success_label = QtWidgets.QLabel(self.build)
        self.success_label.setGeometry(QtCore.QRect(15, 350, 261, 111))
        font = QtGui.QFont()
        font.setPointSize(20)
        self.success_label.setFont(font)
        self.success_label.setObjectName("success_label")
        self.product_rating = QtWidgets.QDoubleSpinBox(self.build)
        self.product_rating.setGeometry(QtCore.QRect(20, 120, 62, 22))
        self.product_rating.setDecimals(1)
        self.product_rating.setMaximum(9.9)
        self.product_rating.setSingleStep(0.1)
        self.product_rating.setProperty("value", 7.0)
        self.product_rating.setObjectName("product_rating")
        self.label_31 = QtWidgets.QLabel(self.build)
        self.label_31.setGeometry(QtCore.QRect(90, 120, 171, 21))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.label_31.setFont(font)
        self.label_31.setObjectName("label_31")
        self.tabWidget.addTab(self.build, "")
        self.view = QtWidgets.QWidget()
        self.view.setObjectName("view")
        self.view_dd = QtWidgets.QComboBox(self.view)
        self.view_dd.setGeometry(QtCore.QRect(20, 60, 101, 22))
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Preferred, QtWidgets.QSizePolicy.Maximum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.view_dd.sizePolicy().hasHeightForWidth())
        self.view_dd.setSizePolicy(sizePolicy)
        self.view_dd.setEditable(False)
        self.view_dd.setMaxVisibleItems(15)
        self.view_dd.setObjectName("view_dd")
        self.view_dd.addItem("")
        self.view_dd.addItem("")
        self.view_dd.addItem("")
        self.view_dd.addItem("")
        self.view_dd.addItem("")
        self.view_dd.addItem("")
        self.view_dd.addItem("")
        self.view_dd.addItem("")
        self.view_dd.addItem("")
        self.view_dd.addItem("")
        self.label_7 = QtWidgets.QLabel(self.view)
        self.label_7.setGeometry(QtCore.QRect(60, 40, 31, 16))
        font = QtGui.QFont()
        font.setPointSize(11)
        self.label_7.setFont(font)
        self.label_7.setObjectName("label_7")
        self.view_table = QtWidgets.QTableWidget(self.view)
        self.view_table.setGeometry(QtCore.QRect(165, 10, 891, 609))
        self.view_table.setObjectName("view_table")
        self.view_table.setColumnCount(0)
        self.view_table.setRowCount(0)
        self.tabWidget.addTab(self.view, "")
        a.setCentralWidget(self.centre)
        self.statusbar = QtWidgets.QStatusBar(a)
        self.statusbar.setObjectName("statusbar")
        a.setStatusBar(self.statusbar)

        self.retranslateUi(a)
        self.tabWidget.setCurrentIndex(0)
        QtCore.QMetaObject.connectSlotsByName(a)

    def retranslateUi(self, a):
        _translate = QtCore.QCoreApplication.translate
        a.setWindowTitle(_translate("a", "PC Builder"))
        self.label.setText(_translate("a", "₺"))
        self.label_2.setText(_translate("a", "Minimum Seller Rating"))
        self.label_3.setText(_translate("a", "Minimum Brand Rating"))
        self.label_4.setText(_translate("a", "Minimum Warranty"))
        self.purpose_dd.setCurrentText(_translate("a", "Working"))
        self.purpose_dd.setItemText(0, _translate("a", "Working"))
        self.purpose_dd.setItemText(1, _translate("a", "Gaming"))
        self.label_5.setText(_translate("a", "Purpose of use"))
        self.focus_dd.setItemText(0, _translate("a", "User Interaction"))
        self.focus_dd.setItemText(1, _translate("a", "Performance"))
        self.label_6.setText(_translate("a", "Focus"))
        self.bring.setText(_translate("a", "Build My Computer!"))
        self.label_8.setText(_translate("a", "CPU"))
        self.label_9.setText(_translate("a", "GPU"))
        self.label_10.setText(_translate("a", "Disk"))
        self.label_11.setText(_translate("a", "RAM"))
        self.label_12.setText(_translate("a", "MOTHERBOARD"))
        self.label_13.setText(_translate("a", "MONITOR"))
        self.label_14.setText(_translate("a", "CASE"))
        self.label_15.setText(_translate("a", "PSU"))
        self.error_label.setText(_translate("a", "<html><head/><body><p align=\"center\"><span style=\" color:#e10000;\">Cannot build</span></p><p align=\"center\"><span style=\" color:#e10000;\">build such a </span></p><p align=\"center\"><span style=\" color:#e10000;\">computer!<br/></span><span style=\" font-family:\'-apple-system\',\'BlinkMacSystemFont\',\'segoe ui\',\'Roboto\',\'Oxygen\',\'Ubuntu\',\'Cantarell\',\'fira sans\',\'droid sans\',\'helvetica neue\',\'sans-serif\'; font-size:20pt; color:#333333; background-color:#ffffff;\">¯\\_(ツ)_/¯</span></p></body></html>"))
        self.success_label.setText(_translate("a", "<html><head/><body><p><span style=\" font-size:24pt;\">Total Price:</span></p></body></html>"))
        self.label_31.setText(_translate("a", "Minimum Product Rating"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.build), _translate("a", "Build"))
        self.view_dd.setCurrentText(_translate("a", "Ram"))
        self.view_dd.setItemText(0, _translate("a", "Ram"))
        self.view_dd.setItemText(1, _translate("a", "Disk"))
        self.view_dd.setItemText(2, _translate("a", "CPU"))
        self.view_dd.setItemText(3, _translate("a", "GPU"))
        self.view_dd.setItemText(4, _translate("a", "Motherboard"))
        self.view_dd.setItemText(5, _translate("a", "Monitor"))
        self.view_dd.setItemText(6, _translate("a", "PSU"))
        self.view_dd.setItemText(7, _translate("a", "Case"))
        self.view_dd.setItemText(8, _translate("a", "Seller"))
        self.view_dd.setItemText(9, _translate("a", "Brand"))
        self.label_7.setText(_translate("a", "View"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.view), _translate("a", "View"))

        self.view_dd_changed()
        self.view_dd.activated.connect(self.view_dd_changed)
        self.bring.clicked.connect(self.build_clicked)
        self.error_label.setHidden(True)
        self.success_label.setHidden(True)
        self.ram_table.setRowCount(1)
        self.ram_table.verticalHeader().setVisible(False)
        self.disk_table.setRowCount(1)
        self.disk_table.verticalHeader().setVisible(False)
        self.cpu_table.setRowCount(1)
        self.cpu_table.verticalHeader().setVisible(False)
        self.gpu_table.setRowCount(1)
        self.gpu_table.verticalHeader().setVisible(False)
        self.mb_table.setRowCount(1)
        self.mb_table.verticalHeader().setVisible(False)
        self.monitor_table.setRowCount(1)
        self.monitor_table.verticalHeader().setVisible(False)
        self.case_table.setRowCount(1)
        self.case_table.verticalHeader().setVisible(False)
        self.psu_table.setRowCount(1)
        self.psu_table.verticalHeader().setVisible(False)

if __name__ == "__main__":
    conn = pyodbc.connect('Driver={SQL Server};'
                          'Server=.\sqlexpress;'
                          'Database=build_pc;'
                          'Trusted_Connection=yes;')

    app = QtWidgets.QApplication(sys.argv)
    a = QtWidgets.QMainWindow()
    ui = Ui_a()
    ui.connect_db(conn)
    ui.setupUi(a)

    a.show()
    sys.exit(app.exec_())
