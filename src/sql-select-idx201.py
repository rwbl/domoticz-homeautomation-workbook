#!/usr/bin/env python
## File: sql-select-idx201.py
## Project:	Domoticz-Homeautomation-Workbook
## Purpose:	Test selecting device status for device with idx=201
## Author: Robert W.B. Linn
## Version:	20191218
import sqlite3
from sqlite3 import Error
import time
import os

version="SQL Test v20191218"
database="/home/pi/domoticz/domoticz.db"

def DatabaseExists(database):
    if not os.path.exists(database):
        print("Database %s not found." % (database))
        return False
    else:
        print("Database %s found." % (database))
        return True

def create_connection(db_file):
    """ create a database connection to the SQLite database
        specified by the db_file
    :param db_file: Database file
    :return: Connection object or None
    """
    try:
        conn = sqlite3.connect(db_file)
        return conn
    except Error as e:
        print(e)
 
    return None

def select_device_status(conn,idx):
    """
    Query rows table DeviceStatus for a specific device ID (=Idx)
    :param conn: connection object
    :param idx: idx of the device
    :return:
    """
    print("Select Device Status for Idx=%s " % (idx))
    cur = conn.cursor()
    table = "DeviceStatus"

    sql = "SELECT group_concat(name, ', ') FROM pragma_table_info(?)"
    args = (table,)
    cur.execute(sql, args)
    colnames = cur.fetchone()
    print(colnames[0])
    
    sql = "SELECT * FROM {tn} WHERE ID={idx}"
    cur.execute(sql.format(tn=table, idx=str(idx)))
    devicedata = cur.fetchall()
    print(devicedata)
    print("***")
    for row in devicedata:
        print(row)                      #all fields as tupels
        print("-----")
        print("ID (=Idx)=%s" % row[0])  #id with value 201
        print("-----")
        print(row[0],row[1],row[2])     #more fields
        print("***")

def main():
    print(version)
    if DatabaseExists(database):
        print("Connecting to the database...",database)
        # create a database connection
        conn = create_connection(database)
        with conn:
            select_device_status(conn, 201)

        conn.close()

if __name__ == '__main__':
    main()
