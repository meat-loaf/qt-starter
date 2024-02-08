#include <QtWidgets>
#include "test.h"

#include "ui/main_window.h"

#include "util/stuff.h"

int
main(int argc, char* argv[]) {
	QApplication a(argc, argv);
	MainWindow w;
	w.show();
	return a.exec() + argstuff(argc, argv);
}
