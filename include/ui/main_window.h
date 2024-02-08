#ifndef _UI_MAIN_WINDOW_H_
#define _UI_MAIN_WINDOW_H_

#include <QWidget>
#include <QMainWindow>

class MainWindow : public QMainWindow {
	Q_OBJECT;
public:
	MainWindow(QWidget* parent = nullptr);
};

#endif // _UI_MAIN_WINDOW_H_
