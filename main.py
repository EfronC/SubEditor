"""
This was built from these three examples.
- https://gist.github.com/jaseg/657e8ecca3267c0d82ec85d40f423caa
- https://gist.github.com/cosven/b313de2acce1b7e15afda263779c0afc
- https://github.com/mpv-player/mpv-examples/tree/master/libmpv/qml
"""

from PyQt5.QtCore import QUrl, QSize, pyqtSignal, pyqtSlot, QObject, Qt
from PyQt5.QtGui import QOpenGLFramebufferObject
import PyQt5.QtWidgets as QtWidgets

from PyQt5.QtQuick import QQuickFramebufferObject, QQuickView, QQuickItem
from PyQt5.QtQml import qmlRegisterType, QQmlComponent

import ctypes

# HELP: currently, we need import GL module，otherwise it will raise seg fault on Linux(Ubuntu 18.04)
# My guess here is that the GL module, when imported, does some sort of necessary
# init that prevents the seg falt
from OpenGL import GL, GLX

from mpv import MPV, MpvRenderContext, MpvGlGetProcAddressFn

VIEW = None
APP = None

def get_process_address(_, name):
    """This function allows looking up OpenGL functions."""
    address = GLX.glXGetProcAddress(name.decode("utf-8"))
    return ctypes.cast(address, ctypes.c_void_p).value


class MpvObject(QQuickFramebufferObject):
    """MpvObject:
    This is a QML widget that can be used to embed the output of a mpv instance.
    It extends the QQuickFramebufferObject class to implement this functionality."""


    # This signal allows triggers the update function to run on the correct thread
    onUpdate = pyqtSignal()
   
    def __init__(self, parent=None):
        print("Creating MpvObject")
        super(MpvObject, self).__init__(parent)
        self.mpv = MPV(ytdl=True)
        self.mpv_gl = None
        self._proc_addr_wrapper = MpvGlGetProcAddressFn(get_process_address)
        self.onUpdate.connect(self.doUpdate)


    def on_update(self):
        """Function for mpv to call to trigger a framebuffer update"""
        self.onUpdate.emit()

    @pyqtSlot()
    def doUpdate(self):
        """Slot for receiving the update event on the correct thread"""
        global VIEW
        root = VIEW.rootObject()
        textbox = root.findChild(QObject, "subtitle")
        if textbox is not None:
            subtitle = self.mpv._get_property("sub-text")
            textbox.setProperty("text", subtitle)

        percent = self.mpv._get_property("percent-pos")
        slider = root.findChild(QObject, "position")
        slider.setProperty("value", percent)

        self.update()

    def createRenderer(self) -> 'QQuickFramebufferObject.Renderer':
        """Overrides the default createRenderer function to create a
        MpvRenderer instance"""
        print("Calling overridden createRenderer")
        return MpvRenderer(self)

    @pyqtSlot(str)
    def play(self, url):
        """Temporary adapter fuction that allowing playing media from QML"""
        self.mpv.play(url)


class MpvRenderer(QQuickFramebufferObject.Renderer):
    """MpvRenderer:
    This class implements the QQuickFramebufferObject's Renderer subsystem.
    It augments the base renderer with an instance of mpv's render API."""
    def __init__(self, parent = None):
        print("Creating MpvRenderer")
        super(MpvRenderer, self).__init__()
        self.obj = parent
        self.ctx = None

    def createFramebufferObject(self, size: QSize) -> QOpenGLFramebufferObject:
        """Overrides the base createFramebufferObject function, augmenting it to
        create an MpvRenderContext using opengl"""
        if self.obj.mpv_gl is None:
            print("Creating mpv gl")
            self.ctx = MpvRenderContext(self.obj.mpv, 'opengl',
                                        opengl_init_params={
                                            'get_proc_address': self.obj._proc_addr_wrapper
                                        })
            self.ctx.update_cb = self.obj.on_update

        return QQuickFramebufferObject.Renderer.createFramebufferObject(self, size)


    def render(self):
        """Overrides the base render function, calling mpv's render functions instead"""
        if self.ctx:
            factor = self.obj.scale()
            rect = self.obj.size()

            # width and height are floats
            width = int(rect.width() * factor)
            height = int(rect.height() * factor)

            fbo = GL.glGetIntegerv(GL.GL_DRAW_FRAMEBUFFER_BINDING)
            self.ctx.render(flip_y=False, opengl_fbo={'w': width, 'h': height, 'fbo': fbo})


def close_window():
    APP.quit()
    return True


if __name__ == '__main__':
    app = QtWidgets.QApplication([])
    APP = app

    qmlRegisterType(MpvObject, 'mpvtest', 1, 0, "MpvObject")

    view = QQuickView()
    url = QUrl("layouts/main.qml")

    import locale
    locale.setlocale(locale.LC_NUMERIC, 'C')

    view.setSource(url)
    view.show()

    view.showFullScreen()

    VIEW = view

    closeb = view.findChild(QObject, "close")
    closeb.closeApp.connect(close_window)
    app.exec_()
