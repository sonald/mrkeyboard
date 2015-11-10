using Cairo;
using Draw;
using Gdk;
using Gtk;
using Utils;

namespace Application {
    const string app_name = "imageviewer";
    const string dbus_name = "org.mrkeyboard.app.imageviewer";
    const string dbus_path = "/org/mrkeyboard/app/imageviewer";

    [DBus (name = "org.mrkeyboard.app.imageviewer")]
    interface Client : Object {
        public abstract void create_window(string[] args, bool from_dbus) throws IOError;
    }

    [DBus (name = "org.mrkeyboard.app.imageviewer")]
    public class ClientServer : Object {
        public virtual void create_window(string[] args, bool from_dbus=false) {
        }
    }

    public class Window : Interface.Window {
        public ImageView image_view;
        
        public Window(int width, int height, string bid, Buffer buf) {
            base(width, height, bid, buf);
        }
        
        public override void init() {
            image_view = new ImageView(buffer);
            
            image_view.realize.connect((w) => {
                    update_tab_name(image_view.buffer.buffer_path);
                });
            
            box.pack_start(image_view, true, true, 0);
        }        
        
        public void update_tab_name(string path) {
            rename_app_tab(mode_name, buffer_id, GLib.Path.get_basename(path), path);
        }
        
        public override void scroll_vertical(bool scroll_up) {
        }

        public override string get_mode_name() {
            return app_name;
        }
        
        public override Gdk.Window get_event_window() {
            return image_view.get_window();
        }
    }

    public class ImageView : DrawingArea {
        public Buffer buffer;
        public Gdk.Color background_color = Utils.color_from_string("#000000");

        public ImageView(Buffer buf) {
            buffer = buf;
            
            set_can_focus(true);  // make widget can receive key event 
            add_events (Gdk.EventMask.BUTTON_PRESS_MASK
                        | Gdk.EventMask.BUTTON_RELEASE_MASK
                        | Gdk.EventMask.KEY_PRESS_MASK
                        | Gdk.EventMask.KEY_RELEASE_MASK
                        | Gdk.EventMask.POINTER_MOTION_MASK
                        | Gdk.EventMask.LEAVE_NOTIFY_MASK);

            draw.connect(on_draw);
            
            key_press_event.connect((w, e) => {
                    handle_key_press(w, e);

                    return false;
                });
        }
        
        public void handle_key_press(Gtk.Widget widget, Gdk.EventKey key_event) {
            
        }
        
        public bool on_draw(Gtk.Widget widget, Cairo.Context cr) {
            Gtk.Allocation alloc;
            get_allocation(out alloc);
            
            // Draw background.
            Utils.set_context_color(cr, background_color);
            Draw.draw_rectangle(cr, 0, 0, alloc.width, alloc.height);
            
            double scale;
            if (buffer.pixbuf_width > buffer.pixbuf_height) {
                scale = (double)alloc.width / buffer.pixbuf_width;
            } else {
                scale = (double)alloc.height / buffer.pixbuf_height;
            }
            cr.scale(scale, scale);
            Gdk.cairo_set_source_pixbuf(
                cr,
                buffer.pixbuf,
                (alloc.width - buffer.pixbuf_width * scale) / (2 * scale),
                (alloc.height - buffer.pixbuf_height * scale) / (2 * scale));
            cr.paint();

            return true;
        }
    }

    public class Buffer : Interface.Buffer {
        public Gdk.Pixbuf pixbuf;
        public int pixbuf_width;
        public int pixbuf_height;
        public string orientation;
        
        public Buffer(string path) {
            base(path);
            
            try {
                GExiv2.Metadata metadata = new GExiv2.Metadata();
                metadata.open_path(path);
                orientation = metadata.get_tag_interpreted_string("Exif.Image.Orientation");
                
                pixbuf = new Gdk.Pixbuf.from_file(path);
                if (orientation == "right, top") {
                    pixbuf = pixbuf.rotate_simple(Gdk.PixbufRotation.CLOCKWISE);
                }
                pixbuf_width = pixbuf.get_width();
                pixbuf_height = pixbuf.get_height();
            } catch (Error e) {
                stderr.printf("%s\n", e.message);
            }
        }
    }
}