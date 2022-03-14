import cx_Oracle

''' DB Settings '''
DB_USER = 'username'
DB_PASSWORD = 'password'
DB_HOST = 'host.domain.dc'
DB_SERVICE_NAME = 'service'

''' SQL query params '''
OLD_STRING = 'old text'
NEW_STRING = 'new text'
FOLDER_ID = 123456  # Voice - xxxxxx | Tablet - xxxxxxx

REGIONS_ALL = ['AD', 'KGD', 'AMU', 'ZAB', 'KLU', 'PRI', 'SA', 'ULY', 'VGG',
               'KR', 'KO', 'ALT', 'MOS', 'KHM', 'VOR', 'KGN', 'CHE', 'NGR',
               'YEV', 'BA', 'BU', 'LIP', 'YAN', 'SVE', 'UD', 'SAR', 'TA',
               'VLA', 'KB', 'TAM', 'KOS', 'KK', 'AST', 'PNZ', 'PSK', 'TVE',
               'TY', 'SE', 'TUL', 'BRY', 'ME', 'CU', 'BEL', 'CE', 'MUR',
               'MAG', 'KC', 'IRK', 'KAM', 'SMO', 'KL', 'TYU', 'IN', 'KYA',
               'PER', 'SPB', 'DA', 'ARK', 'VLG', 'NVS', 'KDA', 'KIR', 'ORE',
               'SAM', 'KHA', 'OMS', 'MO', 'NIZ', 'KEM', 'IVA', 'RYA', 'STA',
               'KRS', 'SAK', 'AL', 'YAR', 'TOM', 'ORL', 'ROS']

REGIONS = ['AD', 'KGD', 'AMU']  # List of needed regions. Can be added from REGIONS_ALL


dsn = cx_Oracle.makedsn(DB_HOST, 1521, service_name=DB_SERVICE_NAME)
connection = cx_Oracle.connect(DB_USER, DB_PASSWORD, dsn=dsn,
                               encoding="UTF-8")
connection.call_timeout = 120000
cur = connection.cursor()

if connection:
    print('Connection success!')


def sql_update():
    print(f'String "{OLD_STRING}" will be replaced to "{NEW_STRING}"')
    print('Type "exit" for exit.\nDo for all regions?')
    yes_keys = ['y', 'yes', 'Y', 'YES']
    no_keys = ['n', 'no', 'N', 'NO']
    answer = input()
    if answer in yes_keys:
        cur.execute('''
            UPDATE journalarticle
            SET
                content = REPLACE(content, :old_string, :new_string)
            WHERE uuid_ IN (
                SELECT a.uuid_
                FROM journalarticle A
                JOIN (
                SELECT j.resourceprimkey, MAX(VERSION) VERSION
                FROM journalarticle j
                JOIN journalfolder jf ON jf.folderid = j.folderid
                WHERE jf.parentfolderid = :folder_id
                GROUP BY j.resourceprimkey
            ) b ON A.resourceprimkey = b.resourceprimkey AND A.VERSION >= b.VERSION)''',
                    folder_id=FOLDER_ID, old_string=OLD_STRING, new_string=NEW_STRING)
        connection.commit()
        print('Success!')
    elif answer in no_keys:
        for region in REGIONS:
            cur.execute('''
                UPDATE journalarticle
                SET
                    content = REPLACE(content, :old_string, :new_string)
                WHERE uuid_ IN (
                    SELECT a.uuid_
                    FROM journalarticle A
                    JOIN (
                    SELECT j.resourceprimkey, MAX(VERSION) VERSION
                    FROM journalarticle j
                    JOIN journalfolder jf ON jf.folderid = j.folderid
                    WHERE jf.parentfolderid = :folder_id
                    AND jf.NAME = :region
                    GROUP BY j.resourceprimkey
                ) b ON A.resourceprimkey = b.resourceprimkey AND A.VERSION >= b.VERSION)''',
                        folder_id=FOLDER_ID, old_string=OLD_STRING, new_string=NEW_STRING, region=region)
            connection.commit()
            print(f'Success for {region}!')
    elif answer == 'exit':
        quit()
    else:
        print('You should answer yes or no')


if __name__ == '__main__':
    while True:
        sql_update()
