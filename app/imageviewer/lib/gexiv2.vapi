/* gexiv2.vapi generated by vapigen, do not modify. */

[CCode (lower_case_cprefix = "gexiv2_")]
namespace GExiv2 {
	[CCode (cheader_filename = "gexiv2/gexiv2.h")]
	[Compact]
	public class ManagedStreamCallbacks {
		public weak GExiv2.Stream_CanRead CanRead;
		public weak GExiv2.Stream_CanSeek CanSeek;
		public weak GExiv2.Stream_CanWrite CanWrite;
		public weak GExiv2.Stream_Flush Flush;
		public weak GExiv2.Stream_Length Length;
		public weak GExiv2.Stream_Position Position;
		public weak GExiv2.Stream_Read Read;
		public weak GExiv2.Stream_Seek Seek;
		public weak GExiv2.Stream_Write Write;
		public void* handle;
	}
	[CCode (cheader_filename = "gexiv2/gexiv2.h")]
	[Compact]
	public class Metadata {
		[CCode (has_construct_function = false)]
		public Metadata ();
		public void clear ();
		public void clear_comment ();
		public void clear_exif ();
		public void clear_iptc ();
		public bool clear_tag (string tag);
		public void clear_xmp ();
		public void delete_gps_info ();
		public void erase_exif_thumbnail ();
		public bool from_app1_segment ([CCode (array_length = false)] uchar[] data, long n_data) throws GLib.Error;
		public string? generate_xmp_packet (GExiv2.XmpFormatFlags xmp_format_flags, uint32 padding);
		public string? get_comment ();
		public bool get_exif_tag_rational (string tag, out int nom, out int den);
		[CCode (array_length = false, array_null_terminated = true)]
		public string[] get_exif_tags ();
		public bool get_exif_thumbnail (out uchar[] buffer);
		public bool get_exposure_time (out int nom, out int den);
		public double get_fnumber ();
		public double get_focal_length ();
		public bool get_gps_altitude (out double altitude);
		public bool get_gps_info (out double longitude, out double latitude, out double altitude);
		public bool get_gps_latitude (out double latitude);
		public bool get_gps_longitude (out double longitude);
		[CCode (array_length = false, array_null_terminated = true)]
		public string[] get_iptc_tags ();
		public int get_iso_speed ();
		public unowned string get_mime_type ();
		public GExiv2.Orientation get_orientation ();
		public int get_pixel_height ();
		public int get_pixel_width ();
		public GExiv2.PreviewImage get_preview_image (GExiv2.PreviewProperties props);
		[CCode (array_length = false, array_null_terminated = true)]
		public unowned GExiv2.PreviewProperties?[] get_preview_properties ();
		public bool get_supports_exif ();
		public bool get_supports_iptc ();
		public bool get_supports_xmp ();
		public static unowned string? get_tag_description (string tag);
		public string? get_tag_interpreted_string (string tag);
		public static unowned string? get_tag_label (string tag);
		public long get_tag_long (string tag);
		[CCode (array_length = false, array_null_terminated = true)]
		public string[]? get_tag_multiple (string tag);
		public GLib.Bytes? get_tag_raw (string tag);
		public string? get_tag_string (string tag);
		public static unowned string get_tag_type (string tag);
		public string? get_xmp_packet ();
		[CCode (array_length = false, array_null_terminated = true)]
		public string[] get_xmp_tags ();
		public bool has_exif ();
		public bool has_iptc ();
		public bool has_tag (string tag);
		public bool has_xmp ();
		public static bool is_exif_tag (string tag);
		public static bool is_iptc_tag (string tag);
		public static bool is_xmp_tag (string tag);
		public bool open_buf ([CCode (array_length = false)] uchar[] data, long n_data) throws GLib.Error;
		public bool open_path (string path) throws GLib.Error;
		public bool open_stream (GExiv2.ManagedStreamCallbacks cb) throws GLib.Error;
		public static bool register_xmp_namespace (string name, string prefix);
		public bool save_file (string path) throws GLib.Error;
		public bool save_stream (GExiv2.ManagedStreamCallbacks cb) throws GLib.Error;
		public void set_comment (string comment);
		public bool set_exif_tag_rational (string tag, int nom, int den);
		public void set_exif_thumbnail_from_buffer ([CCode (array_length_pos = 1.9)] uchar[] buffer);
		public bool set_exif_thumbnail_from_file (string path) throws GLib.Error;
		public bool set_gps_info (double longitude, double latitude, double altitude);
		public void set_orientation (GExiv2.Orientation orientation);
		public bool set_tag_long (string tag, long value);
		public bool set_tag_multiple (string tag, [CCode (array_length = false, array_null_terminated = true)] string[] values);
		public bool set_tag_string (string tag, string value);
		public bool set_xmp_tag_struct (string tag, GExiv2.StructureType type);
		public static void unregister_all_xmp_namespaces ();
		public static bool unregister_xmp_namespace (string name);
	}
	[CCode (cheader_filename = "gexiv2/gexiv2.h")]
	[Compact]
	public class PreviewImage {
		public unowned uint8[] get_data ();
		public unowned string get_extension ();
		public uint32 get_height ();
		public unowned string get_mime_type ();
		public uint32 get_width ();
		public long write_file (string path);
	}
	[CCode (cheader_filename = "gexiv2/gexiv2.h")]
	[Compact]
	public class PreviewProperties {
		public unowned string get_extension ();
		public uint32 get_height ();
		public unowned string get_mime_type ();
		public uint32 get_size ();
		public uint32 get_width ();
	}
	[CCode (cheader_filename = "gexiv2/gexiv2.h", cprefix = "GEXIV2_LOG_LEVEL_", has_type_id = false)]
	public enum LogLevel {
		DEBUG,
		INFO,
		WARN,
		ERROR,
		MUTE
	}
	[CCode (cheader_filename = "gexiv2/gexiv2.h", cprefix = "GEXIV2_ORIENTATION_", has_type_id = false)]
	public enum Orientation {
		MIN,
		UNSPECIFIED,
		NORMAL,
		HFLIP,
		ROT_180,
		VFLIP,
		ROT_90_HFLIP,
		ROT_90,
		ROT_90_VFLIP,
		ROT_270,
		MAX
	}
	[CCode (cheader_filename = "gexiv2/gexiv2.h", cprefix = "GEXIV2_STRUCTURE_XA_", has_type_id = false)]
	public enum StructureType {
		NONE,
		ALT,
		BAG,
		SEQ,
		LANG
	}
	[CCode (cheader_filename = "gexiv2/gexiv2.h", cprefix = "", has_type_id = false)]
	public enum WrapperSeekOrigin {
		Begin,
		Current,
		End
	}
	[CCode (cheader_filename = "gexiv2/gexiv2.h", cprefix = "GEXIV2_", has_type_id = false)]
	public enum XmpFormatFlags {
		OMIT_PACKET_WRAPPER,
		READ_ONLY_PACKET,
		USE_COMPACT_FORMAT,
		INCLUDE_THUMBNAIL_PAD,
		EXACT_PACKET_LENGTH,
		WRITE_ALIAS_COMMENTS,
		OMIT_ALL_FORMATTING
	}
	[CCode (cheader_filename = "gexiv2/gexiv2.h", has_target = false)]
	public delegate void LogHandler (GExiv2.LogLevel level, string msg);
	[CCode (cheader_filename = "gexiv2/gexiv2.h", has_target = false)]
	public delegate bool Stream_CanRead (void* handle);
	[CCode (cheader_filename = "gexiv2/gexiv2.h", has_target = false)]
	public delegate bool Stream_CanSeek (void* handle);
	[CCode (cheader_filename = "gexiv2/gexiv2.h", has_target = false)]
	public delegate bool Stream_CanWrite (void* handle);
	[CCode (cheader_filename = "gexiv2/gexiv2.h", has_target = false)]
	public delegate void Stream_Flush (void* handle);
	[CCode (cheader_filename = "gexiv2/gexiv2.h", has_target = false)]
	public delegate int64 Stream_Length (void* handle);
	[CCode (cheader_filename = "gexiv2/gexiv2.h", has_target = false)]
	public delegate int64 Stream_Position (void* handle);
	[CCode (cheader_filename = "gexiv2/gexiv2.h", has_target = false)]
	public delegate int32 Stream_Read (void* handle, void* buffer, int32 offset, int32 count);
	[CCode (cheader_filename = "gexiv2/gexiv2.h", has_target = false)]
	public delegate void Stream_Seek (void* handle, int64 offset, GExiv2.WrapperSeekOrigin origin);
	[CCode (cheader_filename = "gexiv2/gexiv2.h", has_target = false)]
	public delegate void Stream_Write (void* handle, void* buffer, int32 offset, int32 count);
	[CCode (cheader_filename = "gexiv2/gexiv2.h")]
	public const int MAJOR_VERSION;
	[CCode (cheader_filename = "gexiv2/gexiv2.h")]
	public const int MICRO_VERSION;
	[CCode (cheader_filename = "gexiv2/gexiv2.h")]
	public const int MINOR_VERSION;
	[CCode (cheader_filename = "gexiv2/gexiv2.h")]
	public static int get_version ();
	[CCode (cheader_filename = "gexiv2/gexiv2.h")]
	public static bool initialize ();
	[CCode (cheader_filename = "gexiv2/gexiv2.h")]
	public static unowned GExiv2.LogHandler log_get_default_handler ();
	[CCode (cheader_filename = "gexiv2/gexiv2.h")]
	public static unowned GExiv2.LogHandler log_get_handler ();
	[CCode (cheader_filename = "gexiv2/gexiv2.h")]
	public static GExiv2.LogLevel log_get_level ();
	[CCode (cheader_filename = "gexiv2/gexiv2.h")]
	public static void log_set_handler (GExiv2.LogHandler handler);
	[CCode (cheader_filename = "gexiv2/gexiv2.h")]
	public static void log_set_level (GExiv2.LogLevel level);
	[CCode (cheader_filename = "gexiv2/gexiv2.h")]
	public static void log_use_glib_logging ();
}
