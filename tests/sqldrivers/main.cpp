#include <QDebug>
#include <QSqlDatabase>
int main()
{
  qDebug() << QSqlDatabase::drivers();
  return 0;
}
