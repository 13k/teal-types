-- vim: ft=teal expandtab sw=2 ts=2

global record vim
  -- TODO:
  -- vim.treesitter

  record Cmd
    record Magic
      file: boolean -- The command expands filenames. Which means characters such as "%", "#" and wildcards are expanded.
      bar: boolean -- The "|" character is treated as a command separator and the double quote character (") is treated as the start of a comment.
    end

    record Mods
      record Filter
        pattern: string -- Filter pattern. Empty string if there is no filter.
        force: boolean -- Whether filter is inverted or not.
      end

      enum Split
        "aboveleft" -- |:aboveleft|.
        "belowright" -- |:belowright|.
        "topleft" -- |:topleft|.
        "botright" -- |:botright|.
      end

      filter: Filter -- |:filter|.
      silent: boolean -- |:silent|.
      emsg_silent: boolean -- |:silent!|.
      unsilent: boolean -- |:unsilent|.
      sandbox: boolean -- |:sandbox|.
      noautocmd: boolean -- |:noautocmd|.
      browse: boolean -- |:browse|.
      confirm: boolean -- |:confirm|.
      hide: boolean -- |:hide|.
      horizontal: boolean -- |:horizontal|.
      keepalt: boolean -- |:keepalt|.
      keepjumps: boolean -- |:keepjumps|.
      keepmarks: boolean -- |:keepmarks|.
      keeppatterns: boolean -- |:keeppatterns|.
      lockmarks: boolean -- |:lockmarks|.
      noswapfile: boolean -- |:noswapfile|.
      tab: integer -- |:tab|. -1 when omitted.
      verbose: integer -- |:verbose|. -1 when omitted.
      vertical: boolean -- |:vertical|.
      split: Split -- Split modifier string, is an empty string when there's no split modifier. If there is a split modifier it can be one of:
    end

    cmd: string -- Command name.
    range: {integer, integer} -- Command range (|<line1>| |<line2>|). Omitted if command doesn't accept a range. Otherwise, has no elements if no range was specified, one element if only a single range item was specified, or two elements if both range items were specified.
    count: integer -- Command |<count>|. Omitted if command cannot take a count.
    reg: string -- Command |<register>|. Omitted if command cannot take a register.
    bang: boolean -- Whether command contains a |<bang>| (!) modifier.
    args: {string} -- Command arguments.
    addr: string -- Value of |:command-addr|. Uses short name or "line" for -addr=lines.
    nargs: string -- Value of |:command-nargs|.
    nextcmd: string -- Next command if there are multiple commands separated by a |:bar|. Empty if there isn't a next command.
    magic: Magic -- Which characters have special meaning in the command arguments.
    mods: Mods -- |:command-modifiers|.
  end

  record cmd
    metamethod __call: function(self: cmd, cmd: string)
    metamethod __call: function(self: cmd, cmd: Cmd)
    metamethod __index: function(cmd, string): (function(...: any): any)
  end

  -- TODO: Either find a way to generate these or at least find a comprehensive list to put a bunch
  -- of 'TODO' stub definitions here.
  -- Sadly, there doesn't seem to be a nice way to serialize all of these since they're lazily
  -- brought in as you call them.
  -- This might be the only way since user defined functions are also called here, for example:
  -- `vim.fn["MyPlugin#MyFunction"]()`.
  fn: {string: (function(...: any): any...)}
  call: function(func: string, ...: any): any...

  enum Mode
    "n" -- Normal
    "no" -- Operator-pending
    "nov" -- Operator-pending (forced charwise |o_v|)
    "noV" -- Operator-pending (forced linewise |o_V|)
    "no" -- Operator-pending (forced blockwise |o_CTRL-V|)
    "niI" -- Normal using |i_CTRL-O| in |Insert-mode|
    "niR" -- Normal using |i_CTRL-O| in |Replace-mode|
    "niV" -- Normal using |i_CTRL-O| in |Virtual-Replace-mode|
    "v" -- Visual by character
    "V" -- Visual by line
    "" -- Visual blockwise
    "s" -- Select by character
    "S" -- Select by line
    "" -- Select blockwise
    "i" -- Insert
    "ic" -- Insert mode completion |compl-generic|
    "ix" -- Insert mode |i_CTRL-X| completion
    "R" -- Replace |R|
    "Rc" -- Replace mode completion |compl-generic|
    "Rv" -- Virtual Replace |gR|
    "Rx" -- Replace mode |i_CTRL-X| completion
    "c" -- Command-line editing
    "cv" -- Vim Ex mode |gQ|
    "ce" -- Normal Ex mode |Q|
    "r" -- Hit-enter prompt
    "rm" -- The -- more -- prompt
    "r?" -- |:confirm| query of some sort
    "!" -- Shell or external command is executing
    "t" -- Terminal mode: keys go to the job
  end

  record InspectOptions
    depth: integer
    newline: string
    indent: string
    process: function
  end

  inspect: function(any, InspectOptions): string
  print: function(...: any)

  record log
    record levels
      TRACE: integer -- 0
      DEBUG: integer -- 1
      INFO: integer -- 2
      WARN: integer -- 3
      ERROR: integer -- 4
      OFF: integer -- 5
    end
  end

  record SplitOptions
    plain: boolean
    trimempty: boolean
  end

  notify: function(msg: string, log_level: integer, opts: table)
  notify_once: function(msg: string, level: integer, opt: table)
  paste: function({string}, integer): boolean
  schedule_wrap: function(function): function
  defer_fn: function(function, integer)
  is_callable: function(any): boolean
  pesc: function(string): string
  wait: function(integer)

  record SystemOpts
    -- Set the current working directory for the sub-process.
    cwd: string
    -- Set environment variables for the new process. Inherits the current environment with `NVIM`
    -- set to |v:servername|.
    env: {string: string}
    -- `env` defines the job environment exactly, instead of merging current environment.
    clear_env: boolean
    -- If `true`, then a pipe to stdin is opened and can be written to via the `write()` method to
    -- SystemObj. If string or string[] then will be written to stdin and closed. Defaults to
    -- `false`.
    stdin: string | {string} | boolean
    -- Handle output from stdout. When passed as a function must have the signature
    -- `fun(err: string, data: string)`. Defaults to `true`
    stdout: boolean | function
    -- Handle output from stdout. When passed as a function must have the signature
    -- `fun(err: string, data: string)`. Defaults to `true`.
    stderr: boolean | function
    -- Handle stdout and stderr as text. Replaces `\r\n` with `\n`.
    text: boolean
    --
    timeout: integer
    -- If true, spawn the child process in a detached state - this will make it a process group
    -- leader, and will effectively enable the child to keep running after the parent exits. Note
    -- that the child process will still keep the parent's event loop alive unless the parent
    -- process calls |uv.unref()| on the child's process handle.
    detach: boolean
  end

  record SystemCompleted
    code: integer
    signal: integer
    stdout: string
    stderr: string
  end

  record SystemObj
    pid: integer

    wait: function(self: SystemObj, timeout: integer): SystemCompleted
    kill: function(self: SystemObj, signal: integer)
    write: function(self: SystemObj, data: string)
    is_closing: function(self: SystemObj): boolean
  end

  system: function(cmd: {string}, opts: SystemOpts): SystemObj
  system: function(cmd: {string}, opts: SystemOpts, on_exit: function(SystemCompleted))

  deep_equal: function(any, any): boolean
  deepcopy: function<T>(T): T

  startswith: function(string, string): boolean
  endswith: function(string, string): boolean
  gsplit: function(string, string, SplitOptions): function(): string
  split: function(string, string, SplitOptions): {string}
  trim: function(string): string

  -- TODO
  -- diff: function(a: string, b: string, options: DiffOptions): string | {integer}
  diff: function(a: string, b: string): string

  list_contains: function<T>(t: {T}, value: T): boolean
  list_extend: function<T>(dst: {T}, src: {T}, start: integer, finish: integer): {T}
  list_extend: function<T, U>(dst: {T}, src: {U}, start: integer, finish: integer): {T | U}
  list_slice: function<T>(list: {T}, start: integer, finish: integer): {T}

  enum TableExtendBehavior
    "error"
    "keep"
    "force"
  end

  tbl_add_reverse_lookup: function(table)
  tbl_contains: function<T>({T}, T): boolean
  tbl_count: function(table): integer
  tbl_extend: function(TableExtendBehavior, table, table, ...: table): table
  tbl_extend: function<T>(TableExtendBehavior, {T:any}, {T:any}, ...: {T:any}): {T:any}
  tbl_extend: function<T>(TableExtendBehavior, {any:T}, {any:T}, ...: {any:T}): {any:T}
  tbl_extend: function<T,V>(TableExtendBehavior, {T:V}, {T:V}, ...: {T:V}): {T:V}
  tbl_deep_extend: function(TableExtendBehavior, table, table, ...: table): table
  tbl_deep_extend: function<T>(TableExtendBehavior, {T:any}, {T:any}, ...: {T:any}): {T:any}
  tbl_deep_extend: function<T>(TableExtendBehavior, {any:T}, {any:T}, ...: {any:T}): {any:T}
  tbl_deep_extend: function<T,V>(TableExtendBehavior, {T:V}, {T:V}, ...: {T:V}): {T:V}
  tbl_filter: function<T>(function(T): (boolean), {T})
  tbl_filter: function(function(any): (boolean), {any})
  tbl_flatten: function<T>({T|{T}}): {T}
  tbl_flatten: function({any|{any}}): {any}
  tbl_get: function(table, ...: any): any
  tbl_isempty: function(table): boolean
  tbl_islist: function(table): boolean
  tbl_keys: function<T>({T:any}): {T}
  tbl_values: function<T>({any:T}): {T}
  tbl_map: function<A, B, C>(function(B): (C), {A:B}): {A:C}
  tbl_map: function(function(any): (any), table): table

  enum TypeName
    "table" "t"
    "string" "s"
    "number" "n"
    "boolean" "b"
    "function" "f"
    "nil"
    "thread"
    "userdata"
  end

  -- Technically, this should be a union of tuples since the types are dependent and this allows for invalid combos
  validate: function({string:{any, TypeName | {TypeName} | function(any): (boolean, string), boolean | string}})
  -- should be {string:{any, TypeName, boolean} | {any, function(any): (boolean, string)}, string}}

  record Regex
    match_str: function(Regex, string): integer, integer
    match_line: function(Regex, integer, integer, integer, integer): integer, integer
  end

  regex: function(string): Regex

  record VersionInfo
    api_compatible: integer
    api_level: integer
    api_prerelease: integer
    major: integer
    minor: integer
    patch: integer
  end

  version: function(): VersionInfo

  uri_from_bufnr: function(bufnr: integer): string
  uri_from_fname: function(path: string): string
  uri_to_bufnr: function(uri: string): integer
  uri_to_fname: function(uri: string): string

  region: function(bufnr: integer, pos1: {integer}, pos2: {integer}, regtype: string, inclusive: boolean): {integer:{integer}}

  record filetype
    -- TODO - replace table with options record
    add: function(filetypes: table)

    match: function(name: string, bufnr: integer)
  end

  record mpack
    encode: function(obj: any): string
    decode: function(str: string): any
  end

  record spell
    check: function(str: string): {{string | integer}}
  end

  -- Types taken from neovim's `luvref.txt`
  -- Inheritance is "solved" by copy-pasting everything from parent types into child types
  record uv
    -- {{{ pseudo-types

    type buffer = string | {string}
    type threadargs = nil | boolean | number | string

    record Time
      sec: integer
      usec: integer
    end

    -- }}} pseudo-types
    -- {{{ luv-error-handling

    enum Error
      "E2BIG" -- argument list too long.
      "EACCES" -- permission denied.
      "EADDRINUSE" -- address already in use.
      "EADDRNOTAVAIL" -- address not available.
      "EAFNOSUPPORT" -- address family not supported.
      "EAGAIN" -- resource temporarily unavailable.
      "EAI_ADDRFAMILY" -- address family not supported.
      "EAI_AGAIN" -- temporary failure.
      "EAI_BADFLAGS" -- bad ai_flags value.
      "EAI_BADHINTS" -- invalid value for hints.
      "EAI_CANCELED" -- request canceled.
      "EAI_FAIL" -- permanent failure.
      "EAI_FAMILY" -- ai_family not supported.
      "EAI_MEMORY" -- out of memory.
      "EAI_NODATA" -- no address.
      "EAI_NONAME" -- unknown node or service.
      "EAI_OVERFLOW" -- argument buffer overflow.
      "EAI_PROTOCOL" -- resolved protocol is unknown.
      "EAI_SERVICE" -- service not available for socket type.
      "EAI_SOCKTYPE" -- socket type not supported.
      "EALREADY" -- connection already in progress.
      "EBADF" -- bad file descriptor.
      "EBUSY" -- resource busy or locked.
      "ECANCELED" -- operation canceled.
      "ECHARSET" -- invalid Unicode character.
      "ECONNABORTED" -- software caused connection abort.
      "ECONNREFUSED" -- connection refused.
      "ECONNRESET" -- connection reset by peer.
      "EDESTADDRREQ" -- destination address required.
      "EEXIST" -- file already exists.
      "EFAULT" -- bad address in system call argument.
      "EFBIG" -- file too large.
      "EHOSTUNREACH" -- host is unreachable.
      "EINTR" -- interrupted system call.
      "EINVAL" -- invalid argument.
      "EIO" -- i/o error.
      "EISCONN" -- socket is already connected.
      "EISDIR" -- illegal operation on a directory.
      "ELOOP" -- too many symbolic links encountered.
      "EMFILE" -- too many open files.
      "EMSGSIZE" -- message too long.
      "ENAMETOOLONG" -- name too long.
      "ENETDOWN" -- network is down.
      "ENETUNREACH" -- network is unreachable.
      "ENFILE" -- file table overflow.
      "ENOBUFS" -- no buffer space available.
      "ENODEV" -- no such device.
      "ENOENT" -- no such file or directory.
      "ENOMEM" -- not enough memory.
      "ENONET" -- machine is not on the network.
      "ENOPROTOOPT" -- protocol not available.
      "ENOSPC" -- no space left on device.
      "ENOSYS" -- function not implemented.
      "ENOTCONN" -- socket is not connected.
      "ENOTDIR" -- not a directory.
      "ENOTEMPTY" -- directory not empty.
      "ENOTSOCK" -- socket operation on non-socket.
      "ENOTSUP" -- operation not supported on socket.
      "EOVERFLOW" -- value too large for defined data type.
      "EPERM" -- operation not permitted.
      "EPIPE" -- broken pipe.
      "EPROTO" -- protocol error.
      "EPROTONOSUPPORT" -- protocol not supported.
      "EPROTOTYPE" -- protocol wrong type for socket.
      "ERANGE" -- result too large.
      "EROFS" -- read-only file system.
      "ESHUTDOWN" -- cannot send after transport endpoint shutdown.
      "ESPIPE" -- invalid seek.
      "ESRCH" -- no such process.
      "ETIMEDOUT" -- connection timed out.
      "ETXTBSY" -- text file is busy.
      "EXDEV" -- cross-device link not permitted.
      "UNKNOWN" -- unknown error.
      "EOF" -- end of file.
      "ENXIO" -- no such device or address.
      "EMLINK" -- too many links.
      "ENOTTY" -- inappropriate ioctl for device.
      "EFTYPE" -- inappropriate file type or format.
      "EILSEQ" -- illegal byte sequence.
      "ESOCKTNOSUPPORT" -- socket type not supported.
    end

    errno: {Error: integer}

    -- }}} luv-error-handling
    -- {{{ luv-version-checking

    version: function(): integer
    version_string: function(): string

    -- }}} luv-version-checking
    -- {{{ Requests

    -- uv_req_t
    record Request
      userdata

      enum Type
        "connect"
        "fs"
        "getaddrinfo"
        "getnameinfo"
        "shutdown"
        "udp_send"
        "write"
      end

      cancel: function(self: Request): integer, string, string
      get_type: function(self: Request): Type, integer
    end

    -- uv_connect_t : uv_req_t
    record Connect
      userdata

      cancel: function(self: Connect): integer, string, string
      get_type: function(self: Connect): Request.Type, integer
    end

    -- uv_fs_t : uv_req_t
    record Fs
      userdata

      cancel: function(self: Fs): integer, string, string
      get_type: function(self: Fs): Request.Type, integer
    end

    -- uv_getaddrinfo_t : uv_req_t
    record GetAddrInfo
      userdata

      cancel: function(self: GetAddrInfo): integer, string, string
      get_type: function(self: GetAddrInfo): Request.Type, integer
    end

    -- uv_getnameinfo_t : uv_req_t
    record GetNameInfo
      userdata

      cancel: function(self: GetNameInfo): integer, string, string
      get_type: function(self: GetNameInfo): Request.Type, integer
    end

    -- uv_shutdown_t : uv_req_t
    record Shutdown
      userdata

      cancel: function(self: Shutdown): integer, string, string
      get_type: function(self: Shutdown): Request.Type, integer
    end

    -- uv_udp_send_t : uv_req_t
    record UDPSend
      userdata

      cancel: function(self: UDPSend): integer, string, string
      get_type: function(self: UDPSend): Request.Type, integer
    end

    -- uv_write_t : uv_req_t
    record Write
      userdata

      cancel: function(self: Write): integer, string, string
      get_type: function(self: Write): Request.Type, integer
    end

    -- }}} Requests
    -- {{{ Handles

    -- uv_handle_t
    record Handle
      userdata

      enum Type
        "timer"
        "prepare"
        "check"
        "idle"
        "async"
        "poll"
        "signal"
        "process"
        "tcp"
        "pipe"
        "tty"
        "udp"
        "fs_event"
        "fs_poll"
      end

      is_active: function(self: Handle): boolean, string, string
      is_closing: function(self: Handle): boolean, string, string
      close: function(self: Handle)
      close: function(self: Handle, callback: function())
      send_buffer_size: function(self: Handle, size: integer): integer, string, string
      recv_buffer_size: function(self: Handle, size: integer): integer, string, string
      fileno: function(self: Handle): integer, string, string
      get_type: function(self: Handle): Type, integer
    end

    -- uv_timer_t : uv_handle_t
    record Timer
      userdata

      is_active: function(self: Timer): boolean, string, string
      is_closing: function(self: Timer): boolean, string, string
      close: function(self: Timer)
      close: function(self: Timer, callback: function())
      send_buffer_size: function(self: Timer, size: integer): integer, string, string
      recv_buffer_size: function(self: Timer, size: integer): integer, string, string
      fileno: function(self: Timer): integer, string, string
      get_type: function(self: Timer): Handle.Type, integer

      start: function(self: Timer, timeout: integer, repeat_: integer, callback: function()): integer, string, string
      stop: function(self: Timer): integer, string, string
      again: function(self: Timer): integer, string, string
      set_repeat: function(self: Timer, repeat_: integer)
      get_repeat: function(self: Timer): integer
      get_due_in: function(self: Timer): integer
    end

    new_timer: function(): Timer, string, string

    -- uv_prepare_t : uv_handle_t
    record Prepare
      userdata

      is_active: function(self: Prepare): boolean, string, string
      is_closing: function(self: Prepare): boolean, string, string
      close: function(self: Prepare)
      close: function(self: Prepare, callback: function())
      send_buffer_size: function(self: Prepare, size: integer): integer, string, string
      recv_buffer_size: function(self: Prepare, size: integer): integer, string, string
      fileno: function(self: Prepare): integer, string, string
      get_type: function(self: Prepare): Handle.Type, integer

      start: function(self: Prepare, callback: function()): integer, string, string
      stop: function(self: Prepare): integer, string, string
    end

    new_prepare: function(): Prepare, string, string

    -- uv_check_t : uv_handle_t
    record Check
      userdata

      is_active: function(self: Check): boolean, string, string
      is_closing: function(self: Check): boolean, string, string
      close: function(self: Check)
      close: function(self: Check, callback: function())
      send_buffer_size: function(self: Check, size: integer): integer, string, string
      recv_buffer_size: function(self: Check, size: integer): integer, string, string
      fileno: function(self: Check): integer, string, string
      get_type: function(self: Check): Handle.Type, integer

      start: function(self: Check, callback: function()): integer, string, string
      stop: function(self: Check): integer, string, string
    end

    new_check: function(): Check, string, string

    -- uv_idle_t : uv_handle_t
    record Idle
      userdata

      is_active: function(self: Idle): boolean, string, string
      is_closing: function(self: Idle): boolean, string, string
      close: function(self: Idle)
      close: function(self: Idle, callback: function())
      send_buffer_size: function(self: Idle, size: integer): integer, string, string
      recv_buffer_size: function(self: Idle, size: integer): integer, string, string
      fileno: function(self: Idle): integer, string, string
      get_type: function(self: Idle): Handle.Type, integer

      start: function(self: Idle, callback: function()): integer, string, string
      stop: function(self: Idle): integer, string, string
    end

    new_idle: function(): Idle, string, string

    -- uv_async_t : uv_handle_t
    record Async
      userdata

      is_active: function(self: Async): boolean, string, string
      is_closing: function(self: Async): boolean, string, string
      close: function(self: Async)
      close: function(self: Async, callback: function())
      send_buffer_size: function(self: Async, size: integer): integer, string, string
      recv_buffer_size: function(self: Async, size: integer): integer, string, string
      fileno: function(self: Async): integer, string, string
      get_type: function(self: Async): Handle.Type, integer

      send: function(self: Async, ...: threadargs): integer, string, string
    end

    new_async: function(): Async, string, string
    new_async: function(callback: function(...: threadargs)): Async, string, string

    -- uv_poll_t : uv_handle_t
    record Poll
      userdata

      is_active: function(self: Poll): boolean, string, string
      is_closing: function(self: Poll): boolean, string, string
      close: function(self: Poll)
      close: function(self: Poll, callback: function())
      send_buffer_size: function(self: Poll, size: integer): integer, string, string
      recv_buffer_size: function(self: Poll, size: integer): integer, string, string
      fileno: function(self: Poll): integer, string, string
      get_type: function(self: Poll): Handle.Type, integer

      start: function(self: Poll, events: string, callback: function(err: string, events: string)): integer, string, string
      stop: function(self: Poll): integer, string, string
    end

    new_poll: function(fd: integer): Poll, string, string
    new_socket_poll: function(fd: integer): Poll, string, string

    -- uv_signal_t
    record Signal
      userdata

      is_active: function(self: Signal): boolean, string, string
      is_closing: function(self: Signal): boolean, string, string
      close: function(self: Signal)
      close: function(self: Signal, callback: function())
      send_buffer_size: function(self: Signal, size: integer): integer, string, string
      recv_buffer_size: function(self: Signal, size: integer): integer, string, string
      fileno: function(self: Signal): integer, string, string
      get_type: function(self: Signal): Handle.Type, integer

      start: function(self: Signal, signum: integer | string, callback: function(err: string)): integer, string, string
      start_oneshot: function(self: Signal, signum: integer | string, callback: function(err: string)): integer, string, string
      stop: function(self: Signal): integer, string, string
    end

    new_signal: function(): Signal, string, string

    -- uv_process_t : uv_handle_t
    record Process
      userdata

      record SpawnOptions
        args: {string}
        stdio: {Pipe | integer}
        env: {string: string}
        cwd: string
        uid: integer
        gid: integer
        verbatim: boolean
        detached: boolean
        hide: boolean
      end

      is_active: function(self: Process): boolean, string, string
      is_closing: function(self: Process): boolean, string, string
      close: function(self: Process)
      close: function(self: Process, callback: function())
      send_buffer_size: function(self: Process, size: integer): integer, string, string
      recv_buffer_size: function(self: Process, size: integer): integer, string, string
      fileno: function(self: Process): integer, string, string
      get_type: function(self: Process): Handle.Type, integer

      kill: function(self: Process, signum: integer | string): integer, string, string
      get_pid: function(self: Process): integer
    end

    disable_stdio_inheritance: function()
    spawn: function(path: string, options: Process.SpawnOptions, on_exit: function(code: integer, signal: integer)): Process, integer
    kill: function(pid: integer, signum: integer | string): integer, string, string

    -- Sockets {{{

    record Socket
      enum Family
        "unix"
        "inet"
        "inet6"
        "ipx"
        "netlink"
        "x25"
        "ax25"
        "atmpvc"
        "appletalk"
        "packet"
      end

      enum Type
        "stream"
        "dgram"
        "raw"
        "rdm"
        "seqpacket"
      end

      record Address
        family: Family
        ip: string
        port: integer
      end

      record Flags
        nonblock: boolean
      end
    end

    socketpair: function(): {integer, integer}, string, string
    socketpair: function(socktype: Socket.Type | integer): {integer, integer}, string, string
    socketpair: function(socktype: Socket.Type | integer, protocol: string | integer): {integer, integer}, string, string
    socketpair: function(socktype: Socket.Type | integer, protocol: string | integer, flags1: Socket.Flags): {integer, integer}, string, string
    socketpair: function(socktype: Socket.Type | integer, protocol: string | integer, flags1: Socket.Flags, flags2: Socket.Flags): {integer, integer}, string, string

    -- }}} Sockets
    -- Streams {{{

    -- uv_stream_t : uv_handle_t
    record Stream
      userdata

      is_active: function(self: Stream): boolean, string, string
      is_closing: function(self: Stream): boolean, string, string
      close: function(self: Stream)
      close: function(self: Stream, callback: function())
      send_buffer_size: function(self: Stream, size: integer): integer, string, string
      recv_buffer_size: function(self: Stream, size: integer): integer, string, string
      fileno: function(self: Stream): integer, string, string
      get_type: function(self: Stream): Handle.Type, integer

      shutdown: function(self: Stream): Shutdown, string, string
      shutdown: function(self: Stream, callback: function(err: string)): Shutdown, string, string
      listen: function(self: Stream, backlog: integer, callback: function(err: string)): integer, string, string
      accept: function(self: Stream, client_stream: Stream): integer, string, string
      read_start: function(self: Stream, callback: function(err: string, data: string)): integer, string, string
      read_stop: function(self: Stream): integer, string, string
      write: function(self: Stream, data: buffer): Write, string, string
      write: function(self: Stream, data: buffer, callback: function(err: string)): Write, string, string
      write2: function(self: Stream, data: buffer, send_handle: Stream): Write, string, string
      write2: function(self: Stream, data: buffer, send_handle: Stream, callback: function(err: string)): Write, string, string
      try_write: function(self: Stream, data: buffer): integer, string, string
      try_write2: function(self: Stream, data: buffer, send_handle: Stream): integer, string, string
      is_readable: function(self: Stream): boolean
      is_writable: function(self: Stream): boolean
      set_blocking: function(self: Stream, blocking: boolean): integer, string, string
      get_write_queue_size: function(self: Stream): integer
    end

    -- uv_tcp_t : uv_handle_t, uv_stream_t
    record TCP
      userdata

      record BindOptions
        ipv6only: boolean
      end

      is_active: function(self: TCP): boolean, string, string
      is_closing: function(self: TCP): boolean, string, string
      close: function(self: TCP)
      close: function(self: TCP, callback: function())
      send_buffer_size: function(self: TCP, size: integer): integer, string, string
      recv_buffer_size: function(self: TCP, size: integer): integer, string, string
      fileno: function(self: TCP): integer, string, string
      get_type: function(self: TCP): Handle.Type, integer

      shutdown: function(self: TCP): Shutdown, string, string
      shutdown: function(self: TCP, callback: function(err: string)): Shutdown, string, string
      listen: function(self: TCP, backlog: integer, callback: function(err: string)): integer, string, string
      accept: function(self: TCP, client_stream: Stream): integer, string, string
      read_start: function(self: TCP, callback: function(err: string, data: string)): integer, string, string
      read_stop: function(self: TCP): integer, string, string
      write: function(self: TCP, data: buffer): Write, string, string
      write: function(self: TCP, data: buffer, callback: function(err: string)): Write, string, string
      write2: function(self: TCP, data: buffer, send_handle: Stream): Write, string, string
      write2: function(self: TCP, data: buffer, send_handle: Stream, callback: function(err: string)): Write, string, string
      try_write: function(self: TCP, data: buffer): integer, string, string
      try_write2: function(self: TCP, data: buffer, send_handle: Stream): integer, string, string
      is_readable: function(self: TCP): boolean
      is_writable: function(self: TCP): boolean
      set_blocking: function(self: TCP, blocking: boolean): integer, string, string
      get_write_queue_size: function(self: TCP): integer

      open: function(self: TCP, sock: integer): integer, string, string
      nodelay: function(self: TCP, enable: boolean): integer, string, string
      keepalive: function(self: TCP, enable: boolean): integer, string, string
      keepalive: function(self: TCP, enable: boolean, delay: integer): integer, string, string
      simultaneous_accepts: function(self: TCP, enable: boolean): integer, string, string
      bind: function(self: TCP, host: string, port: integer): integer, string, string
      bind: function(self: TCP, host: string, port: integer, flags: BindOptions): integer, string, string
      getpeername: function(self: TCP): Socket.Address, string, string
      getsockname: function(self: TCP): Socket.Address, string, string
      connect: function(self: TCP, host: string, port: integer, callback: function(err: string)): Connect, string, string
      close_reset: function(self: TCP): integer, string, string
      close_reset: function(self: TCP, callback: function()): integer, string, string
    end

    new_tcp: function(): TCP, string, string
    new_tcp: function(flags: Socket.Family): TCP, string, string

    -- uv_pipe_t : uv_handle_t, uv_stream_t
    record Pipe
      userdata

      record Flags
        nonblock: boolean
      end

      record Pair
        read: integer
        write: integer
      end

      enum ChmodFlags
        "r"
        "w"
        "rw"
        "wr"
      end

      is_active: function(self: Pipe): boolean, string, string
      is_closing: function(self: Pipe): boolean, string, string
      close: function(self: Pipe)
      close: function(self: Pipe, callback: function())
      send_buffer_size: function(self: Pipe, size: integer): integer, string, string
      recv_buffer_size: function(self: Pipe, size: integer): integer, string, string
      fileno: function(self: Pipe): integer, string, string
      get_type: function(self: Pipe): Handle.Type, integer

      shutdown: function(self: Pipe): Shutdown, string, string
      shutdown: function(self: Pipe, callback: function(err: string)): Shutdown, string, string
      listen: function(self: Pipe, backlog: integer, callback: function(err: string)): integer, string, string
      accept: function(self: Pipe, client_stream: Stream): integer, string, string
      read_start: function(self: Pipe, callback: function(err: string, data: string)): integer, string, string
      read_stop: function(self: Pipe): integer, string, string
      write: function(self: Pipe, data: buffer): Write, string, string
      write: function(self: Pipe, data: buffer, callback: function(err: string)): Write, string, string
      write2: function(self: Pipe, data: buffer, send_handle: Stream): Write, string, string
      write2: function(self: Pipe, data: buffer, send_handle: Stream, callback: function(err: string)): Write, string, string
      try_write: function(self: Pipe, data: buffer): integer, string, string
      try_write2: function(self: Pipe, data: buffer, send_handle: Stream): integer, string, string
      is_readable: function(self: Pipe): boolean
      is_writable: function(self: Pipe): boolean
      set_blocking: function(self: Pipe, blocking: boolean): integer, string, string
      get_write_queue_size: function(self: Pipe): integer

      open: function(self: Pipe, fd: integer): integer, string, string
      bind: function(self: Pipe, name: string): integer, string, string
      connect: function(self: Pipe, name: string): Connect, string, string
      connect: function(self: Pipe, name: string, callback: function(err: string)): Connect, string, string
      getsockname: function(self: Pipe): string, string, string
      getpeername: function(self: Pipe): string, string, string
      pending_instances: function(self: Pipe, count: integer)
      pending_count: function(self: Pipe): integer
      pending_type: function(self: Pipe): Handle.Type
      chmod: function(self: Pipe, flags: ChmodFlags): integer, string, string
    end

    new_pipe: function(): Pipe, string, string
    new_pipe: function(ipc: boolean): Pipe, string, string

    pipe: function(read_flags: Pipe.Flags, write_flags: Pipe.Flags): Pipe.Pair

    -- uv_tty_t : uv_handle_t, uv_stream_t
    record TTY
      userdata

      enum VTermState
        "supported"
        "unsupported"
      end

      is_active: function(self: TTY): boolean, string, string
      is_closing: function(self: TTY): boolean, string, string
      close: function(self: TTY)
      close: function(self: TTY, callback: function())
      send_buffer_size: function(self: TTY, size: integer): integer, string, string
      recv_buffer_size: function(self: TTY, size: integer): integer, string, string
      fileno: function(self: TTY): integer, string, string
      get_type: function(self: TTY): Handle.Type, integer

      shutdown: function(self: TTY): Shutdown, string, string
      shutdown: function(self: TTY, callback: function(err: string)): Shutdown, string, string
      listen: function(self: TTY, backlog: integer, callback: function(err: string)): integer, string, string
      accept: function(self: TTY, client_stream: Stream): integer, string, string
      read_start: function(self: TTY, callback: function(err: string, data: string)): integer, string, string
      read_stop: function(self: TTY): integer, string, string
      write: function(self: TTY, data: buffer): Write, string, string
      write: function(self: TTY, data: buffer, callback: function(err: string)): Write, string, string
      write2: function(self: TTY, data: buffer, send_handle: Stream): Write, string, string
      write2: function(self: TTY, data: buffer, send_handle: Stream, callback: function(err: string)): Write, string, string
      try_write: function(self: TTY, data: buffer): integer, string, string
      try_write2: function(self: TTY, data: buffer, send_handle: Stream): integer, string, string
      is_readable: function(self: TTY): boolean
      is_writable: function(self: TTY): boolean
      set_blocking: function(self: TTY, blocking: boolean): integer, string, string
      get_write_queue_size: function(self: TTY): integer

      set_mode: function(self: TTY, mode: integer): integer, string, string
      get_winsize: function(self: TTY): integer, integer, string, string
    end

    new_tty: function(fd: integer, readable: boolean): TTY, string, string

    tty_reset_mode: function(): TTY, string, string
    tty_set_vterm_state: function(state: TTY.VTermState)
    tty_get_vterm_state: function(): TTY.VTermState, string, string

    -- }}} Streams

    -- uv_udp_t : uv_handle_t
    record UDP
      userdata

      record Flags
        family: Socket.Family
        mmsgs: integer
      end

      record BindFlags
        ipv6only: boolean
        reuseaddr: boolean
      end

      record RecvFlags
        partial: boolean
        mmsg_chunk: boolean
      end

      enum MulticastMembership
        "join"
        "leave"
      end

      is_active: function(self: UDP): boolean, string, string
      is_closing: function(self: UDP): boolean, string, string
      close: function(self: UDP)
      close: function(self: UDP, callback: function())
      send_buffer_size: function(self: UDP, size: integer): integer, string, string
      recv_buffer_size: function(self: UDP, size: integer): integer, string, string
      fileno: function(self: UDP): integer, string, string
      get_type: function(self: UDP): Handle.Type, integer

      get_send_queue_size: function(self: UDP): integer
      get_send_queue_count: function(self: UDP): integer
      open: function(self: UDP, fd: integer): integer, string, string
      bind: function(self: UDP, host: string, port: integer): integer, string, string
      bind: function(self: UDP, host: string, port: integer, flags: BindFlags): integer, string, string
      getsockname: function(self: UDP): Socket.Address
      getpeername: function(self: UDP): Socket.Address
      set_membership: function(self: UDP, multicast_addr: string, interface_addr: string, membership: MulticastMembership): integer, string, string
      set_source_membership: function(self: UDP, multicast_addr: string, interface_addr: string, source_addr: string, membership: MulticastMembership): integer, string, string
      set_multicast_loop: function(self: UDP, on: boolean): integer, string, string
      set_multicast_ttl: function(self: UDP, ttl: integer): integer, string, string
      set_multicast_interface: function(self: UDP, interface_addr: string): integer, string, string
      set_broadcast: function(self: UDP, on: boolean): integer, string, string
      set_ttl: function(self: UDP, ttl: integer): integer, string, string
      send: function(self: UDP, data: buffer, host: string, port: integer, callback: function(err: string)): UDPSend
      try_send: function(self: UDP, data: buffer, host: string, port: integer): integer, string, string
      recv_start: function(self: UDP, callback: function(err: string, data: string, addr: Socket.Address, flags: RecvFlags)): integer, string, string
      recv_stop: function(self: UDP): integer, string, string
      connect: function(self: UDP, host: string, port: integer): integer, string, string
    end

    new_udp: function(): UDP, string, string
    new_udp: function(flags: UDP.Flags): UDP, string, string

    -- uv_fs_event_t : uv_handle_t
    record FsEvent
      userdata

      record StartFlags
        watch_entry: boolean
        stat: boolean
        recursive: boolean
      end

      record StartEvents
        change: boolean
        rename: boolean
      end

      type StartCallback = function(err: string, filename: string, events: StartEvents)

      is_active: function(self: FsEvent): boolean, string, string
      is_closing: function(self: FsEvent): boolean, string, string
      close: function(self: FsEvent)
      close: function(self: FsEvent, callback: function())
      send_buffer_size: function(self: FsEvent, size: integer): integer, string, string
      recv_buffer_size: function(self: FsEvent, size: integer): integer, string, string
      fileno: function(self: FsEvent): integer, string, string
      get_type: function(self: FsEvent): Handle.Type, integer

      start: function(self: FsEvent, path: string, flags: StartFlags, callback: StartCallback): integer, string, string
      stop: function(self: FsEvent): integer, string, string
      getpath: function(self: FsEvent): string, string, string
    end

    new_fs_event: function(): FsEvent, string, string

    -- uv_fs_poll_t : uv_handle_t
    record FsPoll
      userdata

      type StartCallback = function(err: string, prev: FsStat, curr: FsStat)

      is_active: function(self: FsPoll): boolean, string, string
      is_closing: function(self: FsPoll): boolean, string, string
      close: function(self: FsPoll)
      close: function(self: FsPoll, callback: function())
      send_buffer_size: function(self: FsPoll, size: integer): integer, string, string
      recv_buffer_size: function(self: FsPoll, size: integer): integer, string, string
      fileno: function(self: FsPoll): integer, string, string
      get_type: function(self: FsPoll): Handle.Type, integer

      start: function(self: FsPoll, path: string, interval: integer, callback: StartCallback): integer, string, string
      stop: function(self: FsPoll): integer, string, string
      getpath: function(self: FsPoll): string, string, string
    end

    new_fs_poll: function(): FsPoll, string, string

    -- }}} Handles
    -- {{{ luv-file-system-operations

    record FsStat
      dev: integer
      mode: integer
      nlink: integer
      uid: integer
      gid: integer
      rdev: integer
      ino: integer
      size: integer
      blksize: integer
      blocks: integer
      flags: integer
      gen: integer
      atime: Time
      mtime: Time
      ctime: Time
      birthtime: Time
      type: string
    end

    record SymlinkFlags
      dir: boolean
      junction: boolean
    end

    record CopyFileFlags
      excl: boolean
      ficlone: boolean
      ficlone_force: boolean
    end

    -- luv_dir_t
    record FsDir
      userdata
    end

    record FsDirEntry
      name: string
      type: string
    end

    record FsStatFs
      type: integer
      bsize: integer
      blocks: integer
      bfree: integer
      bavail: integer
      files: integer
      ffree: integer
    end

    fs_close: function(fd: integer): boolean, string, string
    fs_close: function(fd: integer, callback: function(err: string, success: boolean)): Fs

    fs_open: function(path: string, flags: string | integer, mode: integer): integer, string, string
    fs_open: function(path: string, flags: string | integer, mode: integer, callback: function(err: string, fd: integer)): Fs

    fs_read: function(fd: integer, size: integer, offset: integer): string, string, string
    fs_read: function(fd: integer, size: integer, offset: integer, callback: function(err: string, data: string)): Fs

    fs_unlink: function(path: string): boolean, string, string
    fs_unlink: function(path: string, callback: function(err: string, success: boolean)): Fs

    fs_write: function(fd: integer, data: buffer, offset: integer): integer, string, string
    fs_write: function(fd: integer, data: buffer, offset: integer, callback: function(err: string, bytes: integer)): Fs

    fs_mkdir: function(path: string, mode: integer): boolean, string, string
    fs_mkdir: function(path: string, mode: integer, callback: function(err: string, success: boolean)): Fs

    fs_mkdtemp: function(template: string): string, string, string
    fs_mkdtemp: function(template: string, callback: function(err: string, path: string)): Fs

    fs_mkstemp: function(template: string): integer, string, string, string
    fs_mkstemp: function(template: string, callback: function(err: string, fd: integer, path: string)): Fs

    fs_rmdir: function(path: string): boolean, string, string
    fs_rmdir: function(path: string, callback: function(err: string, success: boolean)): Fs

    fs_scandir: function(path: string): Fs, string, string
    fs_scandir: function(path: string, callback: function(err: string, success: Fs)): Fs
    fs_scandir_next: function(fs: Fs): string, string, string, string

    fs_stat: function(path: string): FsStat, string, string
    fs_stat: function(path: string, callback: function(err: string, stat: FsStat)): Fs

    fs_fstat: function(fd: integer): FsStat, string, string
    fs_fstat: function(fd: integer, callback: function(err: string, stat: FsStat)): Fs

    fs_lstat: function(path: string): FsStat, string, string
    fs_lstat: function(path: string, callback: function(err: string, stat: FsStat)): Fs

    fs_rename: function(path: string, new_path: string): boolean, string, string
    fs_rename: function(path: string, new_path: string, callback: function(err: string, success: boolean)): Fs

    fs_fsync: function(fd: integer): boolean, string, string
    fs_fsync: function(fd: integer, callback: function(err: string, success: boolean)): Fs

    fs_fdatasync: function(fd: integer): boolean, string, string
    fs_fdatasync: function(fd: integer, callback: function(err: string, success: boolean)): Fs

    fs_ftruncate: function(fd: integer, offset: integer): boolean, string, string
    fs_ftruncate: function(fd: integer, offset: integer, callback: function(err: string, success: boolean)): Fs

    fs_sendfile: function(out_fd: integer, in_fd: integer, in_offset: integer, size: integer): integer, string, string
    fs_sendfile: function(out_fd: integer, in_fd: integer, in_offset: integer, size: integer, callback: function(err: string, bytes: integer)): Fs

    fs_access: function(path: string, mode: integer): boolean, string, string
    fs_access: function(path: string, mode: integer, callback: function(err: string, permission: boolean)): Fs

    fs_chmod: function(path: string, mode: integer): boolean, string, string
    fs_chmod: function(path: string, mode: integer, callback: function(err: string, success: boolean)): Fs
    fs_fchmod: function(fd: integer, mode: integer): boolean, string, string
    fs_fchmod: function(fd: integer, mode: integer, callback: function(err: string, success: boolean)): Fs

    fs_utime: function(path: string, atime: number, mtime: number): boolean, string, string
    fs_utime: function(path: string, atime: number, mtime: number, callback: function(err: string, success: boolean)): Fs
    fs_lutime: function(path: string, atime: number, mtime: number): boolean, string, string
    fs_lutime: function(path: string, atime: number, mtime: number, callback: function(err: string, success: boolean)): Fs
    fs_futime: function(fd: integer, atime: number, mtime: number): boolean, string, string
    fs_futime: function(fd: integer, atime: number, mtime: number, callback: function(err: string, success: boolean)): Fs

    fs_link: function(path: string, new_path: string): boolean, string, string
    fs_link: function(path: string, new_path: string, callback: function(err: string, success: boolean)): Fs

    fs_symlink: function(path: string, new_path: string): boolean, string, string
    fs_symlink: function(path: string, new_path: string, flags: SymlinkFlags): boolean, string, string
    fs_symlink: function(path: string, new_path: string, callback: function(err: string, success: boolean)): Fs
    fs_symlink: function(path: string, new_path: string, flags: SymlinkFlags, callback: function(err: string, success: boolean)): Fs

    fs_readlink: function(path: string): string, string, string
    fs_readlink: function(path: string, callback: function(err: string, path: string)): Fs

    fs_realpath: function(path: string): string, string, string
    fs_realpath: function(path: string, callback: function(err: string, path: string)): Fs

    fs_chown: function(path: string, uid: integer, gid: integer): boolean, string, string
    fs_chown: function(path: string, uid: integer, gid: integer, callback: function(err: string, success: boolean)): Fs
    fs_lchown: function(fd: integer, uid: integer, gid: integer): boolean, string, string
    fs_lchown: function(fd: integer, uid: integer, gid: integer, callback: function(err: string, success: boolean)): Fs
    fs_fchown: function(fd: integer, uid: integer, gid: integer): boolean, string, string
    fs_fchown: function(fd: integer, uid: integer, gid: integer, callback: function(err: string, success: boolean)): Fs

    fs_copyfile: function(path: string, new_path: string): boolean, string, string
    fs_copyfile: function(path: string, new_path: string, flags: CopyFileFlags): boolean, string, string
    fs_copyfile: function(path: string, new_path: string, callback: function(err: string, success: boolean)): Fs
    fs_copyfile: function(path: string, new_path: string, flags: CopyFileFlags, callback: function(err: string, success: boolean)): Fs

    fs_opendir: function(path: string): FsDir, string, string
    fs_opendir: function(path: string, callback: nil, entries: integer): FsDir, string, string
    fs_opendir: function(path: string, callback: function(err: string, dir: FsDir)): Fs
    fs_opendir: function(path: string, callback: function(err: string, dir: FsDir), entries: integer): Fs

    fs_readdir: function(dir: FsDir): {FsDirEntry}, string, string
    fs_readdir: function(dir: FsDir, callback: function(err: string, entries: {FsDirEntry})): Fs

    fs_closedir: function(dir: FsDir): boolean, string, string
    fs_closedir: function(dir: FsDir, callback: function(err: string, success: boolean)): Fs

    fs_statfs: function(path: string): FsStatFs, string, string
    fs_statfs: function(path: string, callback: function(err: string, statfs: FsStatFs)): Fs

    -- }}} luv-file-system-operations
    -- {{{ luv-thread-pool-work-scheduling

    -- luv_work_ctx_t
    record WorkCtx
      userdata

      queue_work: function(self: WorkCtx, ...: threadargs): boolean, string, string
    end

    new_work: function(work_callback: function(...: threadargs) | string, after_work_callback: function(...: threadargs)): WorkCtx

    -- }}} luv-thread-pool-work-scheduling
    -- {{{ luv-dns-utility-functions

    record GetAddrInfoHints
      family: Socket.Family | integer
      socktype: Socket.Type | integer
      protocol: string | integer
      addrconfig: boolean
      v4mapped: boolean
      all: boolean
      numerichost: boolean
      passive: boolean
      numericserv: boolean
      canonname: boolean
    end

    record GetAddrInfoAddress
      addr: string
      family: Socket.Family
      port: integer
      socktype: Socket.Type
      protocol: string
      canonname: string
    end

    getaddrinfo: function(host: string, service: string): {GetAddrInfoAddress}, string, string
    getaddrinfo: function(host: string, service: string, hints: GetAddrInfoHints): {GetAddrInfoAddress}, string, string
    getaddrinfo: function(host: string, service: string, hints: GetAddrInfoHints, callback: function(err: string, addresses: {GetAddrInfoAddress})): GetAddrInfo

    getnameinfo: function(address: Socket.Address): string, string, string, string
    getnameinfo: function(address: Socket.Address, callback: function(err: string, host: string, service: string)): GetNameInfo

    -- }}} luv-dns-utility-functions
    -- {{{ luv-threading-and-synchronization-utilities

    -- luv_thread_t
    record Thread
      userdata

      record Options
        stack_size: integer
      end

      equal: function(self: Thread, other_thread: Thread): boolean
      setaffinity: function(self: Thread, affinity: {boolean}): boolean, string, string
      setaffinity: function(self: Thread, affinity: {boolean}, get_old_affinity: boolean): boolean | {boolean}, string, string
      getaffinity: function(self: Thread): {boolean}, string, string
      getaffinity: function(self: Thread, mask_size: integer): {boolean}, string, string
      join: function(self: Thread): boolean, string, string
    end

    new_thread: function(entry: function(...: threadargs) | string, ...: threadargs): Thread, string, string
    new_thread: function(options: Thread.Options, entry: function(...: threadargs) | string, ...: threadargs): Thread, string, string
    thread_getcpu: function(): integer, string, string
    thread_self: function(): Thread
    sleep: function(msec: integer)

    -- }}} luv-threading-and-synchronization-utilities
    -- {{{ luv-miscellaneous-utilities

    record ResourceUsage
      utime: Time -- user CPU time used
      stime: Time -- system CPU time used
      maxrss: integer -- maximum resident set size
      ixrss: integer -- integral shared memory size
      idrss: integer -- integral unshared data size
      isrss: integer -- integral unshared stack size
      minflt: integer -- page reclaims (soft page faults)
      majflt: integer -- page faults (hard page faults)
      nswap: integer -- swaps
      inblock: integer -- block input operations
      oublock: integer -- block output operations
      msgsnd: integer -- IPC messages sent
      msgrcv: integer -- IPC messages received
      nsignals: integer -- signals received
      nvcsw: integer -- voluntary context switches
      nivcsw: integer -- involuntary context switches
    end

    record CpuInfo
      record Times
        user: number
        nice: number
        sys: number
        idle: number
        irq: number
      end

      model: string
      speed: number
      times: Times
    end

    record NetworkInterface
      ip: string
      family: string
      netmask: string
      internal: boolean
      mac: string
    end

    record OsUname
      sysname: string
      release: string
      version: string
      machine: string
    end

    record OsPasswdEntry
      username: string
      uid: integer
      gid: integer
      shell: string
      homedir: string
    end

    exepath: function(): string, string, string
    cwd: function(): string, string, string
    chdir: function(cwd: string): integer, string, string
    get_process_title: function(): string, string, string
    set_process_title: function(title: string): integer, string, string
    get_total_memory: function(): integer
    get_free_memory: function(): integer
    get_constrained_memory: function(): integer
    get_available_memory: function(): integer
    resident_set_memory: function(): integer, string, string
    getrusage: function(): ResourceUsage, string, string
    available_parallelism: function(): integer
    cpu_info: function(): {CpuInfo}, string, string
    cpumask_size: function(): integer, string, string
    getuid: function(): integer
    getgid: function(): integer
    setuid: function(id: integer)
    setgid: function(id: integer)
    hrtime: function(): number
    clock_gettime: function(clock_id: string): Time, string, string
    uptime: function(): number, string, string
    guess_handle: function(fd: integer): string
    gettimeofday: function(): integer, integer, string, string
    interface_addresses: function(): {string: NetworkInterface}
    if_indextoname: function(ifindex: integer): string, string, string
    if_indextoiid: function(ifindex: integer): string, string, string
    loadavg: function(): number, number, number
    os_uname: function(): OsUname
    os_gethostname: function(): string
    os_getenv: function(name: string): string, string, string
    os_getenv: function(name: string, size: integer): string, string, string
    os_setenv: function(name: string, value: string): boolean, string, string
    os_unsetenv: function(): boolean, string, string
    os_environ: function(): {string: string}
    os_homedir: function(): string, string, string
    os_tmpdir: function(): string, string, string
    os_get_passwd: function(): OsPasswdEntry
    os_getpid: function(): integer
    os_getppid: function(): integer
    os_getpriority: function(pid: integer): integer, string, string
    os_setpriority: function(pid: integer, priority: integer): boolean, string, string
    random: function(len: integer, flags: nil): string, string, string
    random: function(len: integer, flags: nil, callback: function(err: string, bytes: string)): integer, string, string
    translate_sys_error: function(errcode: integer): string, string

    -- }}} luv-miscellaneous-utilities
    -- {{{ luv-metrics-operations

    record MetricsInfo
      loop_count: integer
      events: integer
      events_waiting: integer
    end

    metrics_idle_time: function(): number
    metrics_info: function(): MetricsInfo

    -- }}} luv-metrics-operations
  end

  in_fast_event: function(): boolean

  type NIL = record userdata end -- special nil for filling tables

  empty_dict: function(): table
  on_key: function(function(string), integer): integer

  rpcnotify: function(integer, string, ...: string)
  rpcrequest: function(integer, string, ...: string)

  stricmp: function(string, string): integer
  str_utfindex: function(string, integer): integer, integer
  str_byteindex: function(string, integer, boolean): integer

  schedule: function(function)

  schedule_wrap: function(function): function

  type_idx: boolean

  val_idx: boolean

  types: {string|integer:string|integer}

  record keymap
    record DelOptions
      buffer: boolean | integer
    end

    record SetOptions
      buffer: boolean | integer
      callback: function
      desc: string
      expr: boolean
      nowait: boolean
      remap: boolean
      replace_keycodes: boolean
      script: boolean
      silent: boolean
      unique: boolean
    end

    set: function(mode: string|{string}, lhs: string, rhs: string|function(), opts: SetOptions)
    del: function(modes: string|{string}, lhs: string, opts: DelOptions)
  end

  record EventData --TODO: this is a vim thing, so types aren't really documented
    abort: any
    chan: integer
    cmdlevel: any
    cmdtype: any
    cwd: string
    inclusive: boolean
    scope: any
    operator: any
    regcontents: any
    regname: any
    regtype: any
    visual: any
    completed_item: any
    height: any
    width: any
    row: integer
    col: integer
    size: any
    scrollbar: any
    changed_window: any
  end

  record highlight
    record Opts
      higroup: string
      timeout: integer
      on_macro: boolean
      on_visual: boolean
      event: EventData
    end

    on_yank: function(Opts)
    range: function(
      bufnr: integer,
      ns: integer,
      higroup: string,
      start: {integer, integer},
      finish: {integer, integer},
      rtype: any,
      inclusive: boolean
    )
  end

  record diagnostic
    record Severity -- would be great if this could be a tuplerecord
      {string}
      ERROR: integer
      WARN: integer
      INFO: integer
      HINT: integer
      E: integer
      W: integer
      I: integer
      H: integer
    end

    severity: Severity

    record Diagnostic
      lnum: integer -- The starting line of the diagnostic
      end_lnum: integer -- The final line of the diagnostic
      col: integer -- The starting column of the diagnostic
      end_col: integer -- The final column of the diagnostic
      severity: integer -- The severity of the diagnostic |vim.diagnostic.severity|
      message: string -- The diagnostic text
      source: string -- The source of the diagnostic
    end

    record ConfigOpts
      record UnderlineOpts
        severity: integer -- vim.diagnostic.severity
      end

      record VirtualTextOpts
        severity: integer -- vim.diagnostic.severity
        source: string
        format: function(diagnostic: Diagnostic): string
      end

      record SignsOpts
        severity: integer
        priority: integer
      end

      underline: boolean|UnderlineOpts
      virtual_text: boolean|VirtualTextOpts
      signs: boolean|SignsOpts
      float: OpenFloatOpts
      update_in_insert: boolean
      severity_sort: boolean
    end

    record GetOpts
      namespace: integer
      lnum: integer
      severity: integer -- vim.diagnostic.severity
    end

    record GotoOpts
      namespace: integer
      cursor_position: {integer, integer}
      wrap: boolean
      severity: integer -- vim.diagnostic.severity
      float: boolean|OpenFloatOpts
      win_id: integer
    end

    record OpenFloatOpts
      enum Scope
        "buffer"
        "line"
        "cursor"
      end

      namespace: integer
      scope: Scope
      pos: integer|{integer, integer}
      severity_sort: boolean
      severity: integer -- vim.diagnostic.severity
      header: string|{string, string}
      source: string
      format: function(diagnostic: Diagnostic): string
      prefix: string|{string, string}|function(diagnostic: Diagnostic, i: integer, total: integer): string, string
    end

    record SetLocListOpts
      namespace: integer
      winnr: integer
      open: boolean
      title: string
      severity: integer -- vim.diagnostic.severity
    end

    record SetQfListOpts
      namespace: integer
      open: boolean
      title: string
      severity: integer -- vim.diagnostic.severity
    end

    config: function(opts: ConfigOpts, namespace: integer)
    disable: function(bufnr: integer, namespace: integer)
    enable: function(bufnr: integer, namespace: integer)
    fromqflist: function(list: {any}): {Diagnostic}
    get: function(bufnr: integer, opts: GetOpts)
    get_namespace: function(namespace: integer): {string:integer}
    get_namespace: function(namespace: integer): {{string:integer}}
    get_next: function(opts: GotoOpts): Diagnostic
    get_next_pos: function(opts: GotoOpts): {integer, integer}
    get_prev: function(opts: GotoOpts): Diagnostic
    get_prev_pos: function(opts: GotoOpts): {integer, integer}
    goto_next: function(opts: GotoOpts)
    goto_prev: function(opts: GotoOpts)
    hide: function(namespace: integer, bufnr: integer)
    match: function(str: string, pat: string, groups: {string}, severity_map: {string:string}, defaults: {string:any}): Diagnostic
    open_float: function(opts: OpenFloatOpts): {integer, integer}
    reset: function(namespace: integer, bufnr: integer)
    set: function(namespace: integer, bufnr: integer, diagnostics: {Diagnostic}, opts: ConfigOpts)
    setloclist: function(opts: SetLocListOpts)
    setqflist: function(opts: SetQfListOpts)
    show: function(namespace: integer, bufnr: integer, diagnostics: {Diagnostic}, opts: ConfigOpts)
    toqflist: function({Diagnostic}): {string:any}
  end

  record lsp
    record buf
      hover: function
    end

    buf_attach_client: function(bufnr: integer, client_id: integer)
    buf_get_clients: function(bufnr: integer)
    buf_is_attached: function(bufnr: integer, client_id: integer)
    buf_notify: function(bufnr: integer, method: string, params: string): boolean
    buf_request: function(bufnr: integer, method: string, params: table, handler: function): {integer:integer}, function
    buf_request_sync: function(bufnr: integer, method: string, params: table, timeout_ms: integer): {integer:integer}, string

    enum Trace
      "off"
      "messages"
      "verbose"
    end

    record ClientConfig
      cmd: {string} | function(dispatchers: table): table
      cmd_cwd: string
      cmd_env: {string: string}
      detached: boolean
      workspace_folders: table
      capabilities: ClientCapabilities
      handlers: {string: function()}
      settings: table
      commands: table
      init_options: table
      name: string
      get_language_id: function(bufnr: integer, filetype: string): string
      offset_encoding: string
      on_error: function(code: integer)
      before_init: function
      on_init: function
      on_exit: function(code: integer, signal: integer, client_id: integer)
      on_attach: function(client: Client, bufnr: integer)
      trace: Trace
      flags: table
      root_dir: string
    end

    record Client
      record SupportsMethodOptions
        bufnr: integer
      end

      record RequestSyncResponse
        err: ResponseError
        result: any
      end

      id: integer
      name: string
      config: ClientConfig
      server_capabilities: ClientCapabilities

      request: function(method: string, params: any, handler: Handler, bufnr: integer): boolean, integer
      request_sync: function(method: string, params: any, timeout_ms: integer, bufnr: integer): RequestSyncResponse, string
      notify: function(method: string, params: any): boolean
      cancel_request: function(id: integer): boolean
      stop: function(force: boolean)
      is_stopped: function(): boolean
      on_attach: function(client: Client, bufnr: integer)
      supports_method: function(method: string, options: SupportsMethodOptions): boolean
    end

    -- types {{{
    -- TODO: auto-generate
    -- <nvim_runtime>/lua/vim/lsp/types.lua

    type Handler = function(err: ResponseError, result: any, context: HandlerContext, config: table): any

    record HandlerContext
      method: string
      client_id: integer
      bufnr: integer
      params: any
    end

    record ResponseError
      code: integer
      message: string
      data: any
    end

    record ShowMessageRequestParams
      type: MessageType
      message: string
      actions: {MessageActionItem}
    end

    record MessageActionItem
      title: string
    end

    record FileEvent
      uri: string
      type: FileChangeType
    end

    record Position
      line: integer
      character: integer
    end

    record Range
      start: Position
      ["end"]: Position
    end

    record Diagnostic
      range: Range
      message: string
      severity: DiagnosticSeverity
      code: integer | string
      source: string
      tags: {DiagnosticTag}
      relatedInformation: {DiagnosticRelatedInformation}
    end

    record DocumentFilter
      language: string
      scheme: string
      pattern: string
    end

    type DocumentSelector = {DocumentFilter}

    --- @alias RegisterOptions any | StaticRegistrationOptions | TextDocumentRegistrationOptions
    record RegisterOptions
      id: string
      documentSelector: DocumentSelector
    end

    record Registration
      id: string
      method: string
      registerOptions: RegisterOptions
    end

    record RegistrationParams
      registrations: {Registration}
    end

    record StaticRegistrationOptions
      id: string
    end

    record TextDocumentRegistrationOptions
      documentSelector: DocumentSelector
    end

    record Unregistration
      id: string
      method: string
    end

    record UnregistrationParams
      unregisterations: {Unregistration}
    end

    record Location
      uri: string
      range: Range
    end

    record MarkupContent
      kind: string
      value: string
    end

    record InlayHintLabelPart
      value: string
      tooltip: string | MarkupContent
      location: Location
    end

    record TextEdit
      range: Range
      newText: string
    end

    record InlayHint
      position: Position
      label: string | {InlayHintLabelPart}
      kind: integer
      textEdits: {TextEdit}
      paddingLeft: boolean
      paddingRight: boolean
    end

    -- }}} types
    -- protocol {{{
    -- TODO: auto-generate
    -- https://raw.githubusercontent.com/microsoft/lsprotocol/main/generator/lsp.json

    type uinteger = integer

    type MessageType = integer
      -- Error (1)
      -- Warning (2)
      -- Info (3)
      -- Log (4)

    type FileChangeType = integer
      -- Created (1)
      -- Changed (2)
      -- Deleted (3)

    type DiagnosticSeverity = integer
      -- Error (1)
      -- Warning (2)
      -- Information (3)
      -- Hint (4)

    enum FoldingRangeKind
      "comment" -- Comment
      "imports" -- Imports
      "region" -- Region
    end

    type SymbolKind = integer
      -- File (1)
      -- Module (2)
      -- Namespace (3)
      -- Package (4)
      -- Class (5)
      -- Method (6)
      -- Property (7)
      -- Field (8)
      -- Constructor (9)
      -- Enum (10)
      -- Interface (11)
      -- Function (12)
      -- Variable (13)
      -- Constant (14)
      -- String (15)
      -- Number (16)
      -- Boolean (17)
      -- Array (18)
      -- Object (19)
      -- Key (20)
      -- Null (21)
      -- EnumMember (22)
      -- Struct (23)
      -- Event (24)
      -- Operator (25)
      -- TypeParameter (26)

    type SymbolTag = integer
      -- Deprecated (1)

    type CompletionItemKind = integer
      -- Text (1)
      -- Method (2)
      -- Function (3)
      -- Constructor (4)
      -- Field (5)
      -- Variable (6)
      -- Class (7)
      -- Interface (8)
      -- Module (9)
      -- Property (10)
      -- Unit (11)
      -- Value (12)
      -- Enum (13)
      -- Keyword (14)
      -- Snippet (15)
      -- Color (16)
      -- File (17)
      -- Reference (18)
      -- Folder (19)
      -- EnumMember (20)
      -- Constant (21)
      -- Struct (22)
      -- Event (23)
      -- Operator (24)
      -- TypeParameter (25)

    type CompletionItemTag = integer
      -- Deprecated (1)

    type InsertTextMode = integer
      -- asIs (1)
      -- adjustIndentation (2)

    enum CodeActionKind
      "" -- Empty
      "quickfix" -- QuickFix
      "refactor" -- Refactor
      "refactor.extract" -- RefactorExtract
      "refactor.inline" -- RefactorInline
      "refactor.rewrite" -- RefactorRewrite
      "source" -- Source
      "source.organizeImports" -- SourceOrganizeImports
      "source.fixAll" -- SourceFixAll
    end

    enum MarkupKind
      "plaintext" -- PlainText
      "markdown" -- Markdown
    end

    enum PositionEncodingKind
      "utf-8" -- UTF8
      "utf-16" -- UTF16
      "utf-32" -- UTF32
    end

    type DiagnosticTag = integer
      -- Unnecessary (1)
      -- Deprecated (2)

    enum ResourceOperationKind
      "create" -- Create
      "rename" -- Rename
      "delete" -- Delete
    end

    enum FailureHandlingKind
      "abort" -- Abort
      "transactional" -- Transactional
      "textOnlyTransactional" -- TextOnlyTransactional
      "undo" -- Undo
    end

    type PrepareSupportDefaultBehavior = integer
      -- Identifier (1)

    enum TokenFormat
      "relative" -- Relative
    end

    record ClientCapabilities
      workspace: WorkspaceClientCapabilities
      textDocument: TextDocumentClientCapabilities
      notebookDocument: NotebookDocumentClientCapabilities
      window: WindowClientCapabilities
      general: GeneralClientCapabilities
      experimental: any
    end

    record WorkspaceClientCapabilities
      applyEdit: boolean
      workspaceEdit: WorkspaceEditClientCapabilities
      didChangeConfiguration: DidChangeConfigurationClientCapabilities
      didChangeWatchedFiles: DidChangeWatchedFilesClientCapabilities
      symbol: WorkspaceSymbolClientCapabilities
      executeCommand: ExecuteCommandClientCapabilities
      workspaceFolders: boolean
      configuration: boolean
      semanticTokens: SemanticTokensWorkspaceClientCapabilities
      codeLens: CodeLensWorkspaceClientCapabilities
      fileOperations: FileOperationClientCapabilities
      inlineValue: InlineValueWorkspaceClientCapabilities
      inlayHint: InlayHintWorkspaceClientCapabilities
      diagnostics: DiagnosticWorkspaceClientCapabilities
    end

    record WorkspaceEditClientCapabilities
      documentChanges: boolean
      resourceOperations: {ResourceOperationKind}
      failureHandling: FailureHandlingKind
      normalizesLineEndings: boolean

      record changeAnnotationSupport
        groupsOnLabel: boolean
      end
    end

    record DidChangeConfigurationClientCapabilities
      dynamicRegistration: boolean
    end

    record DidChangeWatchedFilesClientCapabilities
      dynamicRegistration: boolean
      relativePatternSupport: boolean
    end

    record WorkspaceSymbolClientCapabilities
      dynamicRegistration: boolean

      record symbolKind
        valueSet: {SymbolKind}
      end

      record tagSupport
        valueSet: {SymbolTag}
      end

      record resolveSupport
        properties: {string}
      end
    end

    record ExecuteCommandClientCapabilities
      dynamicRegistration: boolean
    end

    record SemanticTokensWorkspaceClientCapabilities
      refreshSupport: boolean
    end

    record CodeLensWorkspaceClientCapabilities
      refreshSupport: boolean
    end

    record FileOperationClientCapabilities
      dynamicRegistration: boolean
      didCreate: boolean
      willCreate: boolean
      didRename: boolean
      willRename: boolean
      didDelete: boolean
      willDelete: boolean
    end

    record InlineValueWorkspaceClientCapabilities
      refreshSupport: boolean
    end

    record InlayHintWorkspaceClientCapabilities
      refreshSupport: boolean
    end

    record DiagnosticWorkspaceClientCapabilities
      refreshSupport: boolean
    end

    record TextDocumentClientCapabilities
      synchronization: TextDocumentSyncClientCapabilities
      completion: CompletionClientCapabilities
      hover: HoverClientCapabilities
      signatureHelp: SignatureHelpClientCapabilities
      declaration: DeclarationClientCapabilities
      definition: DefinitionClientCapabilities
      typeDefinition: TypeDefinitionClientCapabilities
      implementation: ImplementationClientCapabilities
      references: ReferenceClientCapabilities
      documentHighlight: DocumentHighlightClientCapabilities
      documentSymbol: DocumentSymbolClientCapabilities
      codeAction: CodeActionClientCapabilities
      codeLens: CodeLensClientCapabilities
      documentLink: DocumentLinkClientCapabilities
      colorProvider: DocumentColorClientCapabilities
      formatting: DocumentFormattingClientCapabilities
      rangeFormatting: DocumentRangeFormattingClientCapabilities
      onTypeFormatting: DocumentOnTypeFormattingClientCapabilities
      rename: RenameClientCapabilities
      foldingRange: FoldingRangeClientCapabilities
      selectionRange: SelectionRangeClientCapabilities
      publishDiagnostics: PublishDiagnosticsClientCapabilities
      callHierarchy: CallHierarchyClientCapabilities
      semanticTokens: SemanticTokensClientCapabilities
      linkedEditingRange: LinkedEditingRangeClientCapabilities
      moniker: MonikerClientCapabilities
      typeHierarchy: TypeHierarchyClientCapabilities
      inlineValue: InlineValueClientCapabilities
      inlayHint: InlayHintClientCapabilities
      diagnostic: DiagnosticClientCapabilities
      inlineCompletion: InlineCompletionClientCapabilities
    end

    record TextDocumentSyncClientCapabilities
      dynamicRegistration: boolean
      willSave: boolean
      willSaveWaitUntil: boolean
      didSave: boolean
    end

    record CompletionClientCapabilities
      dynamicRegistration: boolean
      record completionItem
        snippetSupport: boolean
        commitCharactersSupport: boolean
        documentationFormat: {MarkupKind}
        deprecatedSupport: boolean
        preselectSupport: boolean
        record tagSupport
          valueSet: {CompletionItemTag}
        end

        insertReplaceSupport: boolean
        record resolveSupport
          properties: {string}
        end

        record insertTextModeSupport
          valueSet: {InsertTextMode}
        end

        labelDetailsSupport: boolean
      end

      record completionItemKind
        valueSet: {CompletionItemKind}
      end

      insertTextMode: InsertTextMode
      contextSupport: boolean
      record completionList
        itemDefaults: {string}
      end
    end

    record CompletionContext
      triggerKind: CompletionTriggerKind
      triggerCharacter: string
    end

    type CompletionTriggerKind = integer
      -- Invoked (1)
      -- TriggerCharacter (2)
      -- TriggerForIncompleteCompletions (3)

    record CompletionItem
      label: string
      labelDetails: CompletionItemLabelDetails
      kind: CompletionItemKind
      tags: {CompletionItemTag}
      detail: string
      documentation: string|MarkupContent
      deprecated: boolean
      preselect: boolean
      sortText: string
      filterText: string
      insertText: string
      insertTextFormat: InsertTextFormat
      insertTextMode: InsertTextMode
      textEdit: TextEdit_Or_InsertReplaceEdit
      textEditText: string
      additionalTextEdits: {TextEdit}
      commitCharacters: {string}
      command: Command
      data: any
    end

    record TextEdit_Or_InsertReplaceEdit
      range: Range
      newText: string
      --newText: string
      insert: Range
      replace: Range
    end

    type InsertTextFormat = integer
      -- PlainText (1)
      -- Snippet (2)

    record CompletionItemLabelDetails
      detail: string
      description: string
    end

    record InsertReplaceEdit
      newText: string
      insert: Range
      replace: Range
    end

    record Command
      title: string
      command: string
      arguments: {any}
    end

    record HoverClientCapabilities
      dynamicRegistration: boolean
      contentFormat: {MarkupKind}
    end

    record SignatureHelpClientCapabilities
      dynamicRegistration: boolean
      record signatureInformation
        documentationFormat: {MarkupKind}
        record parameterInformation
          labelOffsetSupport: boolean
        end

        activeParameterSupport: boolean
      end

      contextSupport: boolean
    end

    record DeclarationClientCapabilities
      dynamicRegistration: boolean
      linkSupport: boolean
    end

    record DefinitionClientCapabilities
      dynamicRegistration: boolean
      linkSupport: boolean
    end

    record TypeDefinitionClientCapabilities
      dynamicRegistration: boolean
      linkSupport: boolean
    end

    record ImplementationClientCapabilities
      dynamicRegistration: boolean
      linkSupport: boolean
    end

    record ReferenceClientCapabilities
      dynamicRegistration: boolean
    end

    record DocumentHighlightClientCapabilities
      dynamicRegistration: boolean
    end

    record DocumentSymbolClientCapabilities
      dynamicRegistration: boolean
      record symbolKind
        valueSet: {SymbolKind}
      end

      hierarchicalDocumentSymbolSupport: boolean
      record tagSupport
        valueSet: {SymbolTag}
      end

      labelSupport: boolean
    end

    record CodeActionClientCapabilities
      dynamicRegistration: boolean
      record codeActionLiteralSupport
        record codeActionKind
          valueSet: {CodeActionKind}
        end

      end

      isPreferredSupport: boolean
      disabledSupport: boolean
      dataSupport: boolean
      record resolveSupport
        properties: {string}
      end

      honorsChangeAnnotations: boolean
    end

    record CodeLensClientCapabilities
      dynamicRegistration: boolean
    end

    record DocumentLinkClientCapabilities
      dynamicRegistration: boolean
      tooltipSupport: boolean
    end

    record DocumentColorClientCapabilities
      dynamicRegistration: boolean
    end

    record DocumentFormattingClientCapabilities
      dynamicRegistration: boolean
    end

    record DocumentRangeFormattingClientCapabilities
      dynamicRegistration: boolean
      rangesSupport: boolean
    end

    record DocumentOnTypeFormattingClientCapabilities
      dynamicRegistration: boolean
    end

    record RenameClientCapabilities
      dynamicRegistration: boolean
      prepareSupport: boolean
      prepareSupportDefaultBehavior: PrepareSupportDefaultBehavior
      honorsChangeAnnotations: boolean
    end

    record FoldingRangeClientCapabilities
      dynamicRegistration: boolean
      rangeLimit: uinteger
      lineFoldingOnly: boolean
      record foldingRangeKind
        valueSet: {FoldingRangeKind}
      end

      record foldingRange
        collapsedText: boolean
      end

    end

    record SelectionRangeClientCapabilities
      dynamicRegistration: boolean
    end

    record PublishDiagnosticsClientCapabilities
      relatedInformation: boolean
      record tagSupport
        valueSet: {DiagnosticTag}
      end

      versionSupport: boolean
      codeDescriptionSupport: boolean
      dataSupport: boolean
    end

    record CallHierarchyClientCapabilities
      dynamicRegistration: boolean
    end

    record SemanticTokensClientCapabilities
      dynamicRegistration: boolean
      record requests
        range: boolean|anonym10
        full: boolean|anonym11
      end

      tokenTypes: {string}
      tokenModifiers: {string}
      formats: {TokenFormat}
      overlappingTokenSupport: boolean
      multilineTokenSupport: boolean
      serverCancelSupport: boolean
      augmentsSyntaxTokens: boolean
    end

    record LinkedEditingRangeClientCapabilities
      dynamicRegistration: boolean
    end

    record MonikerClientCapabilities
      dynamicRegistration: boolean
    end

    record TypeHierarchyClientCapabilities
      dynamicRegistration: boolean
    end

    record InlineValueClientCapabilities
      dynamicRegistration: boolean
    end

    record InlayHintClientCapabilities
      dynamicRegistration: boolean
      record resolveSupport
        properties: {string}
      end

    end

    record DiagnosticClientCapabilities
      dynamicRegistration: boolean
      relatedDocumentSupport: boolean
    end

    record DiagnosticRelatedInformation
      location: Location
      message: string
    end

    record InlineCompletionClientCapabilities
      dynamicRegistration: boolean
    end

    record NotebookDocumentClientCapabilities
      synchronization: NotebookDocumentSyncClientCapabilities
    end

    record NotebookDocumentSyncClientCapabilities
      dynamicRegistration: boolean
      executionSummarySupport: boolean
    end

    record WindowClientCapabilities
      workDoneProgress: boolean
      showMessage: ShowMessageRequestClientCapabilities
      showDocument: ShowDocumentClientCapabilities
    end

    record ShowMessageRequestClientCapabilities
      record messageActionItem
        additionalPropertiesSupport: boolean
      end

    end

    record ShowDocumentClientCapabilities
      support: boolean
    end

    record GeneralClientCapabilities
      record staleRequestSupport
        cancel: boolean
        retryOnContentModified: {string}
      end

      regularExpressions: RegularExpressionsClientCapabilities
      markdown: MarkdownClientCapabilities
      positionEncodings: {PositionEncodingKind}
    end

    record RegularExpressionsClientCapabilities
      engine: string
      version: string
    end

    record MarkdownClientCapabilities
      parser: string
      version: string
      allowedTags: {string}
    end

    record anonym10
    end

    record anonym11
      delta: boolean
    end

    -- }}} protocol
  end

  g: {string: any}
  t: {string: any}
  v: {string: any}
  b: {string: any}
  w: {string: any}
  env: {string: string}

  -- Option object that handles options that are comma-separated lists (has `commalist` meta
  -- property) and flag sets (has `flaglist` meta property).
  --
  -- The type parameter `T` is the type returned by `opt:get()`:
  --   - commalist option: `{string}`
  --   - flaglist option: `{string: boolean}`
  --   - simple option: option's type (`string`, `integer`, etc)
  --
  -- The type parameter `I` is `T`'s item type, accepted by `opt:append()`, `opt:prepend()` and
  -- `opt:remove()` for commalist or flaglist options. For simple options, it's the same as `T`.
  -- It's present because it's not possible to automatically infer from `T`.
  --
  -- NOTE: This does not cover the valid case
  --   `opt.(name) = (value)`
  -- but it can be worked around by using
  --   `opt.(name) = (value) as vim.Option<T, I>` (T and I as concrete types)
  -- Also, defining metamethods `__index` and `__newindex` (not supported yet by Teal) on
  -- *OptionsObjects records would lose the type for each specific option.
  record Option<T, I>
    get: function(self: Option<T, I>): T
    append: function(self: Option<T, I>, item: I)
    append: function(self: Option<T, I>, item: {I})
    prepend: function(self: Option<T, I>, item: I)
    prepend: function(self: Option<T, I>, item: {I})
    remove: function(self: Option<T, I>, item: I)
    remove: function(self: Option<T, I>, item: {I})

    metamethod __add: function(self: Option<T, I>, item: I): Option<T, I>
    metamethod __pow: function(self: Option<T, I>, item: I): Option<T, I>
    metamethod __sub: function(self: Option<T, I>, item: I): Option<T, I>
  end

  record AllOptions -- {{{
    acd: boolean
    ai: boolean
    al: number
    aleph: number
    allowrevins: boolean
    ambiwidth: string
    ambw: string
    ar: boolean
    arab: boolean
    arabic: boolean
    arabicshape: boolean
    ari: boolean
    arshape: boolean
    autochdir: boolean
    autoindent: boolean
    autoread: boolean
    autowrite: boolean
    autowriteall: boolean
    aw: boolean
    awa: boolean
    background: string
    backspace: string
    backup: boolean
    backupcopy: string
    backupdir: string
    backupext: string
    backupskip: string
    bdir: string
    belloff: string
    bex: string
    bg: string
    bh: string
    bin: boolean
    binary: boolean
    bk: boolean
    bkc: string
    bl: boolean
    bo: string
    bomb: boolean
    breakat: string
    breakindent: boolean
    breakindentopt: string
    bri: boolean
    briopt: string
    brk: string
    browsedir: string
    bs: string
    bsdir: string
    bsk: string
    bt: string
    bufhidden: string
    buflisted: boolean
    buftype: string
    casemap: string
    cb: string
    cc: string
    ccv: string
    cd: string
    cdh: boolean
    cdhome: boolean
    cdpath: string
    cedit: string
    cf: boolean
    cfu: string
    ch: number
    channel: number
    charconvert: string
    ci: boolean
    cin: boolean
    cindent: boolean
    cink: string
    cinkeys: string
    cino: string
    cinoptions: string
    cinscopedecls: string
    cinsd: string
    cinw: string
    cinwords: string
    clipboard: string
    cmdheight: number
    cmdwinheight: number
    cmp: string
    cms: string
    co: number
    cocu: string
    cole: number
    colorcolumn: string
    columns: number
    com: string
    comments: string
    commentstring: string
    compatible: boolean
    complete: string
    completefunc: string
    completeopt: string
    completeslash: string
    concealcursor: string
    conceallevel: number
    confirm: boolean
    copyindent: boolean
    cot: string
    cp: boolean
    cpo: string
    cpoptions: string
    cpt: string
    crb: boolean
    csl: string
    cuc: boolean
    cul: boolean
    culopt: string
    cursorbind: boolean
    cursorcolumn: boolean
    cursorline: boolean
    cursorlineopt: string
    cwh: number
    debug: string
    deco: boolean
    def: string
    define: string
    delcombine: boolean
    dex: string
    dg: boolean
    dict: string
    dictionary: string
    diff: boolean
    diffexpr: string
    diffopt: string
    digraph: boolean
    dip: string
    dir: string
    directory: string
    display: string
    dy: string
    ea: boolean
    ead: string
    eadirection: string
    eb: boolean
    ed: boolean
    edcompatible: boolean
    ef: string
    efm: string
    ei: string
    emo: boolean
    emoji: boolean
    enc: string
    encoding: string
    endoffile: boolean
    endofline: boolean
    eof: boolean
    eol: boolean
    ep: string
    equalalways: boolean
    equalprg: string
    errorbells: boolean
    errorfile: string
    errorformat: string
    et: boolean
    eventignore: string
    ex: boolean
    expandtab: boolean
    exrc: boolean
    fcl: string
    fcs: string
    fdc: string
    fde: string
    fdi: string
    fdl: number
    fdls: number
    fdm: string
    fdn: number
    fdo: string
    fdt: string
    fen: boolean
    fenc: string
    fencs: string
    fex: string
    ff: string
    ffs: string
    fic: boolean
    fileencoding: string
    fileencodings: string
    fileformat: string
    fileformats: string
    fileignorecase: boolean
    filetype: string
    fillchars: string
    fixendofline: boolean
    fixeol: boolean
    flp: string
    fml: number
    fmr: string
    fo: string
    foldclose: string
    foldcolumn: string
    foldenable: boolean
    foldexpr: string
    foldignore: string
    foldlevel: number
    foldlevelstart: number
    foldmarker: string
    foldmethod: string
    foldminlines: number
    foldnestmax: number
    foldopen: string
    foldtext: string
    formatexpr: string
    formatlistpat: string
    formatoptions: string
    formatprg: string
    fp: string
    fs: boolean
    fsync: boolean
    ft: string
    gcr: string
    gd: boolean
    gdefault: boolean
    gfm: string
    gfn: string
    gfw: string
    go: string
    gp: string
    grepformat: string
    grepprg: string
    gtl: string
    gtt: string
    guicursor: string
    guifont: string
    guifontwide: string
    guioptions: string
    guitablabel: string
    guitabtooltip: string
    helpfile: string
    helpheight: number
    helplang: string
    hf: string
    hh: number
    hi: number
    hid: boolean
    hidden: boolean
    highlight: string
    history: number
    hk: boolean
    hkmap: boolean
    hkmapp: boolean
    hkp: boolean
    hl: string
    hlg: string
    hls: boolean
    hlsearch: boolean
    ic: boolean
    icm: string
    icon: boolean
    iconstring: string
    ignorecase: boolean
    im: boolean
    imc: boolean
    imcmdline: boolean
    imd: boolean
    imdisable: boolean
    imi: number
    iminsert: number
    ims: number
    imsearch: number
    inc: string
    inccommand: string
    include: string
    includeexpr: string
    incsearch: boolean
    inde: string
    indentexpr: string
    indentkeys: string
    indk: string
    inex: string
    inf: boolean
    infercase: boolean
    insertmode: boolean
    is: boolean
    isf: string
    isfname: string
    isi: string
    isident: string
    isk: string
    iskeyword: string
    isp: string
    isprint: string
    joinspaces: boolean
    jop: string
    js: boolean
    jumpoptions: string
    keymap: string
    keymodel: string
    keywordprg: string
    km: string
    kmp: string
    kp: string
    langmap: string
    langmenu: string
    langnoremap: boolean
    langremap: boolean
    laststatus: number
    lazyredraw: boolean
    lbr: boolean
    lcs: string
    linebreak: boolean
    lines: number
    linespace: number
    lisp: boolean
    lispoptions: string
    lispwords: string
    list: boolean
    listchars: string
    lm: string
    lmap: string
    lnr: boolean
    loadplugins: boolean
    lop: string
    lpl: boolean
    lrm: boolean
    ls: number
    lsp: number
    lw: string
    lz: boolean
    ma: boolean
    magic: boolean
    makeef: string
    makeencoding: string
    makeprg: string
    mat: number
    matchpairs: string
    matchtime: number
    maxcombine: number
    maxfuncdepth: number
    maxmapdepth: number
    maxmempattern: number
    mco: number
    mef: string
    menc: string
    menuitems: number
    mfd: number
    mh: boolean
    mis: number
    mkspellmem: string
    ml: boolean
    mle: boolean
    mls: number
    mmd: number
    mmp: number
    mod: boolean
    modeline: boolean
    modelineexpr: boolean
    modelines: number
    modifiable: boolean
    modified: boolean
    more: boolean
    mouse: string
    mousef: boolean
    mousefocus: boolean
    mousehide: boolean
    mousem: string
    mousemev: boolean
    mousemodel: string
    mousemoveevent: boolean
    mouses: string
    mousescroll: string
    mouseshape: string
    mouset: number
    mousetime: number
    mp: string
    mps: string
    msm: string
    nf: string
    nrformats: string
    nu: boolean
    number: boolean
    numberwidth: number
    nuw: number
    odev: boolean
    ofu: string
    omnifunc: string
    opendevice: boolean
    operatorfunc: string
    opfunc: string
    pa: string
    packpath: string
    para: string
    paragraphs: string
    paste: boolean
    pastetoggle: string
    patchexpr: string
    patchmode: string
    path: string
    pb: number
    pex: string
    ph: number
    pi: boolean
    pm: string
    pp: string
    preserveindent: boolean
    previewheight: number
    previewwindow: boolean
    prompt: boolean
    pt: string
    pumblend: number
    pumheight: number
    pumwidth: number
    pvh: number
    pvw: boolean
    pw: number
    pyx: number
    pyxversion: number
    qe: string
    qftf: string
    quickfixtextfunc: string
    quoteescape: string
    rdb: string
    rdt: number
    re: number
    readonly: boolean
    redrawdebug: string
    redrawtime: number
    regexpengine: number
    relativenumber: boolean
    remap: boolean
    report: number
    revins: boolean
    ri: boolean
    rightleft: boolean
    rightleftcmd: string
    rl: boolean
    rlc: string
    rnu: boolean
    ro: boolean
    rtp: string
    ru: boolean
    ruf: string
    ruler: boolean
    rulerformat: string
    runtimepath: string
    sb: boolean
    sbo: string
    sbr: string
    sc: boolean
    scb: boolean
    scbk: number
    scl: string
    scr: number
    scroll: number
    scrollback: number
    scrollbind: boolean
    scrolljump: number
    scrolloff: number
    scrollopt: string
    scs: boolean
    sd: string
    sdf: string
    sect: string
    sections: string
    secure: boolean
    sel: string
    selection: string
    selectmode: string
    sessionoptions: string
    sft: boolean
    sh: string
    shada: string
    shadafile: string
    shcf: string
    shell: string
    shellcmdflag: string
    shellpipe: string
    shellquote: string
    shellredir: string
    shellslash: boolean
    shelltemp: boolean
    shellxescape: string
    shellxquote: string
    shiftround: boolean
    shiftwidth: number
    shm: string
    shortmess: string
    showbreak: string
    showcmd: boolean
    showcmdloc: string
    showfulltag: boolean
    showmatch: boolean
    showmode: boolean
    showtabline: number
    shq: string
    si: boolean
    sidescroll: number
    sidescrolloff: number
    signcolumn: string
    siso: number
    sj: number
    slm: string
    sloc: string
    sm: boolean
    smartcase: boolean
    smartindent: boolean
    smarttab: boolean
    smc: number
    smd: boolean
    smoothscroll: boolean
    sms: boolean
    so: number
    softtabstop: number
    sol: boolean
    sp: string
    spc: string
    spell: boolean
    spellcapcheck: string
    spellfile: string
    spelllang: string
    spelloptions: string
    spellsuggest: string
    spf: string
    spk: string
    spl: string
    splitbelow: boolean
    splitkeep: string
    splitright: boolean
    spo: string
    spr: boolean
    sps: string
    sr: boolean
    srr: string
    ss: number
    ssl: boolean
    ssop: string
    sta: boolean
    stal: number
    startofline: boolean
    statuscolumn: string
    statusline: string
    stc: string
    stl: string
    stmp: boolean
    sts: number
    su: string
    sua: string
    suffixes: string
    suffixesadd: string
    sw: number
    swapfile: boolean
    swb: string
    swf: boolean
    switchbuf: string
    sxe: string
    sxq: string
    syn: string
    synmaxcol: number
    syntax: string
    tabline: string
    tabpagemax: number
    tabstop: number
    tag: string
    tagbsearch: boolean
    tagcase: string
    tagfunc: string
    taglength: number
    tagrelative: boolean
    tags: string
    tagstack: boolean
    tal: string
    tbidi: boolean
    tbs: boolean
    tc: string
    tenc: string
    termbidi: boolean
    termencoding: string
    termguicolors: boolean
    termpastefilter: string
    terse: boolean
    textwidth: number
    tf: boolean
    tfu: string
    tgc: boolean
    tgst: boolean
    thesaurus: string
    thesaurusfunc: string
    tildeop: boolean
    timeout: boolean
    timeoutlen: number
    title: boolean
    titlelen: number
    titleold: string
    titlestring: string
    tl: number
    tm: number
    to: boolean
    top: boolean
    tpf: string
    tpm: number
    tr: boolean
    ts: number
    tsr: string
    tsrfu: string
    ttimeout: boolean
    ttimeoutlen: number
    ttm: number
    ttyfast: boolean
    tw: number
    uc: number
    udf: boolean
    udir: string
    ul: number
    undodir: string
    undofile: boolean
    undolevels: number
    undoreload: number
    updatecount: number
    updatetime: number
    ur: number
    ut: number
    varsofttabstop: string
    vartabstop: string
    vb: boolean
    vbs: number
    vdir: string
    ve: string
    verbose: number
    verbosefile: string
    vfile: string
    vi: string
    viewdir: string
    viewoptions: string
    vif: string
    viminfo: string
    viminfofile: string
    virtualedit: string
    visualbell: boolean
    vop: string
    vsts: string
    vts: string
    wa: boolean
    wak: string
    warn: boolean
    wb: boolean
    wbr: string
    wc: number
    wcm: number
    wd: number
    wfh: boolean
    wfw: boolean
    wh: number
    whichwrap: string
    wi: number
    wic: boolean
    wig: string
    wildchar: number
    wildcharm: number
    wildignore: string
    wildignorecase: boolean
    wildmenu: boolean
    wildmode: string
    wildoptions: string
    wim: string
    winaltkeys: string
    winbar: string
    winbl: number
    winblend: number
    window: number
    winfixheight: boolean
    winfixwidth: boolean
    winheight: number
    winhighlight: string
    winhl: string
    winminheight: number
    winminwidth: number
    winwidth: number
    wiw: number
    wm: number
    wmh: number
    wmnu: boolean
    wmw: number
    wop: string
    wrap: boolean
    wrapmargin: number
    wrapscan: boolean
    write: boolean
    writeany: boolean
    writebackup: boolean
    writedelay: number
    ws: boolean
    ww: string
  end -- }}}

  record GlobalOptions -- {{{
    acd: boolean
    al: number
    aleph: number
    allowrevins: boolean
    ambiwidth: string
    ambw: string
    arabicshape: boolean
    ari: boolean
    arshape: boolean
    autochdir: boolean
    autowrite: boolean
    autowriteall: boolean
    aw: boolean
    awa: boolean
    background: string
    backspace: string
    backup: boolean
    backupdir: string
    backupext: string
    backupskip: string
    bdir: string
    belloff: string
    bex: string
    bg: string
    bk: boolean
    bo: string
    breakat: string
    brk: string
    browsedir: string
    bs: string
    bsdir: string
    bsk: string
    casemap: string
    cb: string
    ccv: string
    cd: string
    cdh: boolean
    cdhome: boolean
    cdpath: string
    cedit: string
    cf: boolean
    ch: number
    charconvert: string
    clipboard: string
    cmdheight: number
    cmdwinheight: number
    cmp: string
    co: number
    columns: number
    compatible: boolean
    completeopt: string
    completeslash: string
    confirm: boolean
    cot: string
    cp: boolean
    cpo: string
    cpoptions: string
    csl: string
    cwh: number
    debug: string
    deco: boolean
    delcombine: boolean
    dex: string
    dg: boolean
    diffexpr: string
    diffopt: string
    digraph: boolean
    dip: string
    dir: string
    directory: string
    display: string
    dy: string
    ea: boolean
    ead: string
    eadirection: string
    eb: boolean
    ed: boolean
    edcompatible: boolean
    ef: string
    ei: string
    emo: boolean
    emoji: boolean
    enc: string
    encoding: string
    equalalways: boolean
    errorbells: boolean
    errorfile: string
    eventignore: string
    ex: boolean
    exrc: boolean
    fcl: string
    fdls: number
    fdo: string
    fencs: string
    ffs: string
    fic: boolean
    fileencodings: string
    fileformats: string
    fileignorecase: boolean
    foldclose: string
    foldlevelstart: number
    foldopen: string
    fs: boolean
    fsync: boolean
    gcr: string
    gd: boolean
    gdefault: boolean
    gfm: string
    gfn: string
    gfw: string
    go: string
    grepformat: string
    gtl: string
    gtt: string
    guicursor: string
    guifont: string
    guifontwide: string
    guioptions: string
    guitablabel: string
    guitabtooltip: string
    helpfile: string
    helpheight: number
    helplang: string
    hf: string
    hh: number
    hi: number
    hid: boolean
    hidden: boolean
    highlight: string
    history: number
    hk: boolean
    hkmap: boolean
    hkmapp: boolean
    hkp: boolean
    hl: string
    hlg: string
    hls: boolean
    hlsearch: boolean
    ic: boolean
    icm: string
    icon: boolean
    iconstring: string
    ignorecase: boolean
    im: boolean
    imc: boolean
    imcmdline: boolean
    imd: boolean
    imdisable: boolean
    inccommand: string
    incsearch: boolean
    insertmode: boolean
    is: boolean
    isf: string
    isfname: string
    isi: string
    isident: string
    isp: string
    isprint: string
    joinspaces: boolean
    jop: string
    js: boolean
    jumpoptions: string
    keymodel: string
    km: string
    langmap: string
    langmenu: string
    langnoremap: boolean
    langremap: boolean
    laststatus: number
    lazyredraw: boolean
    lines: number
    linespace: number
    lm: string
    lmap: string
    lnr: boolean
    loadplugins: boolean
    lpl: boolean
    lrm: boolean
    ls: number
    lsp: number
    lz: boolean
    magic: boolean
    makeef: string
    mat: number
    matchtime: number
    maxcombine: number
    maxfuncdepth: number
    maxmapdepth: number
    maxmempattern: number
    mco: number
    mef: string
    menuitems: number
    mfd: number
    mh: boolean
    mis: number
    mkspellmem: string
    mle: boolean
    mls: number
    mmd: number
    mmp: number
    modelineexpr: boolean
    modelines: number
    more: boolean
    mouse: string
    mousef: boolean
    mousefocus: boolean
    mousehide: boolean
    mousem: string
    mousemev: boolean
    mousemodel: string
    mousemoveevent: boolean
    mouses: string
    mousescroll: string
    mouseshape: string
    mouset: number
    mousetime: number
    msm: string
    odev: boolean
    opendevice: boolean
    operatorfunc: string
    opfunc: string
    packpath: string
    para: string
    paragraphs: string
    paste: boolean
    pastetoggle: string
    patchexpr: string
    patchmode: string
    pb: number
    pex: string
    ph: number
    pm: string
    pp: string
    previewheight: number
    prompt: boolean
    pt: string
    pumblend: number
    pumheight: number
    pumwidth: number
    pvh: number
    pw: number
    pyx: number
    pyxversion: number
    qftf: string
    quickfixtextfunc: string
    rdb: string
    rdt: number
    re: number
    redrawdebug: string
    redrawtime: number
    regexpengine: number
    remap: boolean
    report: number
    revins: boolean
    ri: boolean
    rtp: string
    ru: boolean
    ruf: string
    ruler: boolean
    rulerformat: string
    runtimepath: string
    sb: boolean
    sbo: string
    sc: boolean
    scrolljump: number
    scrollopt: string
    scs: boolean
    sd: string
    sdf: string
    sect: string
    sections: string
    secure: boolean
    sel: string
    selection: string
    selectmode: string
    sessionoptions: string
    sft: boolean
    sh: string
    shada: string
    shadafile: string
    shcf: string
    shell: string
    shellcmdflag: string
    shellpipe: string
    shellquote: string
    shellredir: string
    shellslash: boolean
    shelltemp: boolean
    shellxescape: string
    shellxquote: string
    shiftround: boolean
    shm: string
    shortmess: string
    showcmd: boolean
    showcmdloc: string
    showfulltag: boolean
    showmatch: boolean
    showmode: boolean
    showtabline: number
    shq: string
    sidescroll: number
    sj: number
    slm: string
    sloc: string
    sm: boolean
    smartcase: boolean
    smarttab: boolean
    smd: boolean
    sol: boolean
    sp: string
    spellsuggest: string
    spk: string
    splitbelow: boolean
    splitkeep: string
    splitright: boolean
    spr: boolean
    sps: string
    sr: boolean
    srr: string
    ss: number
    ssl: boolean
    ssop: string
    sta: boolean
    stal: number
    startofline: boolean
    stmp: boolean
    su: string
    suffixes: string
    swb: string
    switchbuf: string
    sxe: string
    sxq: string
    tabline: string
    tabpagemax: number
    tagbsearch: boolean
    taglength: number
    tagrelative: boolean
    tagstack: boolean
    tal: string
    tbidi: boolean
    tbs: boolean
    tenc: string
    termbidi: boolean
    termencoding: string
    termguicolors: boolean
    termpastefilter: string
    terse: boolean
    tf: boolean
    tgc: boolean
    tgst: boolean
    tildeop: boolean
    timeout: boolean
    timeoutlen: number
    title: boolean
    titlelen: number
    titleold: string
    titlestring: string
    tl: number
    tm: number
    to: boolean
    top: boolean
    tpf: string
    tpm: number
    tr: boolean
    ttimeout: boolean
    ttimeoutlen: number
    ttm: number
    ttyfast: boolean
    uc: number
    udir: string
    undodir: string
    undoreload: number
    updatecount: number
    updatetime: number
    ur: number
    ut: number
    vb: boolean
    vbs: number
    vdir: string
    verbose: number
    verbosefile: string
    vfile: string
    vi: string
    viewdir: string
    viewoptions: string
    vif: string
    viminfo: string
    viminfofile: string
    visualbell: boolean
    vop: string
    wa: boolean
    wak: string
    warn: boolean
    wb: boolean
    wc: number
    wcm: number
    wd: number
    wh: number
    whichwrap: string
    wi: number
    wic: boolean
    wig: string
    wildchar: number
    wildcharm: number
    wildignore: string
    wildignorecase: boolean
    wildmenu: boolean
    wildmode: string
    wildoptions: string
    wim: string
    winaltkeys: string
    window: number
    winheight: number
    winminheight: number
    winminwidth: number
    winwidth: number
    wiw: number
    wmh: number
    wmnu: boolean
    wmw: number
    wop: string
    wrapscan: boolean
    write: boolean
    writeany: boolean
    writebackup: boolean
    writedelay: number
    ws: boolean
    ww: string
  end -- }}}

  record WindowOptions -- {{{
    arab: boolean
    arabic: boolean
    breakindent: boolean
    breakindentopt: string
    bri: boolean
    briopt: string
    cc: string
    cocu: string
    cole: number
    colorcolumn: string
    concealcursor: string
    conceallevel: number
    crb: boolean
    cuc: boolean
    cul: boolean
    culopt: string
    cursorbind: boolean
    cursorcolumn: boolean
    cursorline: boolean
    cursorlineopt: string
    diff: boolean
    fcs: string
    fdc: string
    fde: string
    fdi: string
    fdl: number
    fdm: string
    fdn: number
    fdt: string
    fen: boolean
    fillchars: string
    fml: number
    fmr: string
    foldcolumn: string
    foldenable: boolean
    foldexpr: string
    foldignore: string
    foldlevel: number
    foldmarker: string
    foldmethod: string
    foldminlines: number
    foldnestmax: number
    foldtext: string
    lbr: boolean
    lcs: string
    linebreak: boolean
    list: boolean
    listchars: string
    nu: boolean
    number: boolean
    numberwidth: number
    nuw: number
    previewwindow: boolean
    pvw: boolean
    relativenumber: boolean
    rightleft: boolean
    rightleftcmd: string
    rl: boolean
    rlc: string
    rnu: boolean
    sbr: string
    scb: boolean
    scl: string
    scr: number
    scroll: number
    scrollbind: boolean
    scrolloff: number
    showbreak: string
    sidescrolloff: number
    signcolumn: string
    siso: number
    smoothscroll: boolean
    sms: boolean
    so: number
    spell: boolean
    statuscolumn: string
    statusline: string
    stc: string
    stl: string
    ve: string
    virtualedit: string
    wbr: string
    wfh: boolean
    wfw: boolean
    winbar: string
    winbl: number
    winblend: number
    winfixheight: boolean
    winfixwidth: boolean
    winhighlight: string
    winhl: string
    wrap: boolean
  end -- }}}

  record BufferOptions -- {{{
    ai: boolean
    ar: boolean
    autoindent: boolean
    autoread: boolean
    backupcopy: string
    bh: string
    bin: boolean
    binary: boolean
    bkc: string
    bl: boolean
    bomb: boolean
    bt: string
    bufhidden: string
    buflisted: boolean
    buftype: string
    cfu: string
    channel: number
    ci: boolean
    cin: boolean
    cindent: boolean
    cink: string
    cinkeys: string
    cino: string
    cinoptions: string
    cinscopedecls: string
    cinsd: string
    cinw: string
    cinwords: string
    cms: string
    com: string
    comments: string
    commentstring: string
    complete: string
    completefunc: string
    copyindent: boolean
    cpt: string
    def: string
    define: string
    dict: string
    dictionary: string
    efm: string
    endoffile: boolean
    endofline: boolean
    eof: boolean
    eol: boolean
    ep: string
    equalprg: string
    errorformat: string
    et: boolean
    expandtab: boolean
    fenc: string
    fex: string
    ff: string
    fileencoding: string
    fileformat: string
    filetype: string
    fixendofline: boolean
    fixeol: boolean
    flp: string
    fo: string
    formatexpr: string
    formatlistpat: string
    formatoptions: string
    formatprg: string
    fp: string
    ft: string
    gp: string
    grepprg: string
    imi: number
    iminsert: number
    ims: number
    imsearch: number
    inc: string
    include: string
    includeexpr: string
    inde: string
    indentexpr: string
    indentkeys: string
    indk: string
    inex: string
    inf: boolean
    infercase: boolean
    isk: string
    iskeyword: string
    keymap: string
    keywordprg: string
    kmp: string
    kp: string
    lisp: boolean
    lispoptions: string
    lispwords: string
    lop: string
    lw: string
    ma: boolean
    makeencoding: string
    makeprg: string
    matchpairs: string
    menc: string
    ml: boolean
    mod: boolean
    modeline: boolean
    modifiable: boolean
    modified: boolean
    mp: string
    mps: string
    nf: string
    nrformats: string
    ofu: string
    omnifunc: string
    pa: string
    path: string
    pi: boolean
    preserveindent: boolean
    qe: string
    quoteescape: string
    readonly: boolean
    ro: boolean
    scbk: number
    scrollback: number
    shiftwidth: number
    si: boolean
    smartindent: boolean
    smc: number
    softtabstop: number
    spc: string
    spellcapcheck: string
    spellfile: string
    spelllang: string
    spelloptions: string
    spf: string
    spl: string
    spo: string
    sts: number
    sua: string
    suffixesadd: string
    sw: number
    swapfile: boolean
    swf: boolean
    syn: string
    synmaxcol: number
    syntax: string
    tabstop: number
    tag: string
    tagcase: string
    tagfunc: string
    tags: string
    tc: string
    textwidth: number
    tfu: string
    thesaurus: string
    thesaurusfunc: string
    ts: number
    tsr: string
    tsrfu: string
    tw: number
    udf: boolean
    ul: number
    undofile: boolean
    undolevels: number
    varsofttabstop: string
    vartabstop: string
    vsts: string
    vts: string
    wm: number
    wrapmargin: number
  end -- }}}

  record AllOptionsObjects -- {{{
    acd: Option<boolean, boolean>
    ai: Option<boolean, boolean>
    al: Option<number, number>
    aleph: Option<number, number>
    allowrevins: Option<boolean, boolean>
    ambiwidth: Option<string, string>
    ambw: Option<string, string>
    ar: Option<boolean, boolean>
    arab: Option<boolean, boolean>
    arabic: Option<boolean, boolean>
    arabicshape: Option<boolean, boolean>
    ari: Option<boolean, boolean>
    arshape: Option<boolean, boolean>
    autochdir: Option<boolean, boolean>
    autoindent: Option<boolean, boolean>
    autoread: Option<boolean, boolean>
    autowrite: Option<boolean, boolean>
    autowriteall: Option<boolean, boolean>
    aw: Option<boolean, boolean>
    awa: Option<boolean, boolean>
    background: Option<string, string>
    backspace: Option<{string}, string>
    backup: Option<boolean, boolean>
    backupcopy: Option<{string}, string>
    backupdir: Option<{string}, string>
    backupext: Option<string, string>
    backupskip: Option<{string}, string>
    bdir: Option<{string}, string>
    belloff: Option<{string}, string>
    bex: Option<string, string>
    bg: Option<string, string>
    bh: Option<string, string>
    bin: Option<boolean, boolean>
    binary: Option<boolean, boolean>
    bk: Option<boolean, boolean>
    bkc: Option<{string}, string>
    bl: Option<boolean, boolean>
    bo: Option<{string}, string>
    bomb: Option<boolean, boolean>
    breakat: Option<{string: boolean}, string>
    breakindent: Option<boolean, boolean>
    breakindentopt: Option<{string}, string>
    bri: Option<boolean, boolean>
    briopt: Option<{string}, string>
    brk: Option<{string: boolean}, string>
    browsedir: Option<string, string>
    bs: Option<{string}, string>
    bsdir: Option<string, string>
    bsk: Option<{string}, string>
    bt: Option<string, string>
    bufhidden: Option<string, string>
    buflisted: Option<boolean, boolean>
    buftype: Option<string, string>
    casemap: Option<{string}, string>
    cb: Option<{string}, string>
    cc: Option<{string}, string>
    ccv: Option<string, string>
    cd: Option<{string}, string>
    cdh: Option<boolean, boolean>
    cdhome: Option<boolean, boolean>
    cdpath: Option<{string}, string>
    cedit: Option<string, string>
    cf: Option<boolean, boolean>
    cfu: Option<string, string>
    ch: Option<number, number>
    channel: Option<number, number>
    charconvert: Option<string, string>
    ci: Option<boolean, boolean>
    cin: Option<boolean, boolean>
    cindent: Option<boolean, boolean>
    cink: Option<{string}, string>
    cinkeys: Option<{string}, string>
    cino: Option<{string}, string>
    cinoptions: Option<{string}, string>
    cinscopedecls: Option<{string}, string>
    cinsd: Option<{string}, string>
    cinw: Option<{string}, string>
    cinwords: Option<{string}, string>
    clipboard: Option<{string}, string>
    cmdheight: Option<number, number>
    cmdwinheight: Option<number, number>
    cmp: Option<{string}, string>
    cms: Option<string, string>
    co: Option<number, number>
    cocu: Option<string, string>
    cole: Option<number, number>
    colorcolumn: Option<{string}, string>
    columns: Option<number, number>
    com: Option<{string}, string>
    comments: Option<{string}, string>
    commentstring: Option<string, string>
    compatible: Option<boolean, boolean>
    complete: Option<{string}, string>
    completefunc: Option<string, string>
    completeopt: Option<{string}, string>
    completeslash: Option<string, string>
    concealcursor: Option<string, string>
    conceallevel: Option<number, number>
    confirm: Option<boolean, boolean>
    copyindent: Option<boolean, boolean>
    cot: Option<{string}, string>
    cp: Option<boolean, boolean>
    cpo: Option<{string: boolean}, string>
    cpoptions: Option<{string: boolean}, string>
    cpt: Option<{string}, string>
    crb: Option<boolean, boolean>
    csl: Option<string, string>
    cuc: Option<boolean, boolean>
    cul: Option<boolean, boolean>
    culopt: Option<{string}, string>
    cursorbind: Option<boolean, boolean>
    cursorcolumn: Option<boolean, boolean>
    cursorline: Option<boolean, boolean>
    cursorlineopt: Option<{string}, string>
    cwh: Option<number, number>
    debug: Option<string, string>
    deco: Option<boolean, boolean>
    def: Option<string, string>
    define: Option<string, string>
    delcombine: Option<boolean, boolean>
    dex: Option<string, string>
    dg: Option<boolean, boolean>
    dict: Option<{string}, string>
    dictionary: Option<{string}, string>
    diff: Option<boolean, boolean>
    diffexpr: Option<string, string>
    diffopt: Option<{string}, string>
    digraph: Option<boolean, boolean>
    dip: Option<{string}, string>
    dir: Option<{string}, string>
    directory: Option<{string}, string>
    display: Option<{string}, string>
    dy: Option<{string}, string>
    ea: Option<boolean, boolean>
    ead: Option<string, string>
    eadirection: Option<string, string>
    eb: Option<boolean, boolean>
    ed: Option<boolean, boolean>
    edcompatible: Option<boolean, boolean>
    ef: Option<string, string>
    efm: Option<{string}, string>
    ei: Option<{string}, string>
    emo: Option<boolean, boolean>
    emoji: Option<boolean, boolean>
    enc: Option<string, string>
    encoding: Option<string, string>
    endoffile: Option<boolean, boolean>
    endofline: Option<boolean, boolean>
    eof: Option<boolean, boolean>
    eol: Option<boolean, boolean>
    ep: Option<string, string>
    equalalways: Option<boolean, boolean>
    equalprg: Option<string, string>
    errorbells: Option<boolean, boolean>
    errorfile: Option<string, string>
    errorformat: Option<{string}, string>
    et: Option<boolean, boolean>
    eventignore: Option<{string}, string>
    ex: Option<boolean, boolean>
    expandtab: Option<boolean, boolean>
    exrc: Option<boolean, boolean>
    fcl: Option<{string}, string>
    fcs: Option<{string}, string>
    fdc: Option<string, string>
    fde: Option<string, string>
    fdi: Option<string, string>
    fdl: Option<number, number>
    fdls: Option<number, number>
    fdm: Option<string, string>
    fdn: Option<number, number>
    fdo: Option<{string}, string>
    fdt: Option<string, string>
    fen: Option<boolean, boolean>
    fenc: Option<string, string>
    fencs: Option<{string}, string>
    fex: Option<string, string>
    ff: Option<string, string>
    ffs: Option<{string}, string>
    fic: Option<boolean, boolean>
    fileencoding: Option<string, string>
    fileencodings: Option<{string}, string>
    fileformat: Option<string, string>
    fileformats: Option<{string}, string>
    fileignorecase: Option<boolean, boolean>
    filetype: Option<string, string>
    fillchars: Option<{string}, string>
    fixendofline: Option<boolean, boolean>
    fixeol: Option<boolean, boolean>
    flp: Option<string, string>
    fml: Option<number, number>
    fmr: Option<{string}, string>
    fo: Option<{string: boolean}, string>
    foldclose: Option<{string}, string>
    foldcolumn: Option<string, string>
    foldenable: Option<boolean, boolean>
    foldexpr: Option<string, string>
    foldignore: Option<string, string>
    foldlevel: Option<number, number>
    foldlevelstart: Option<number, number>
    foldmarker: Option<{string}, string>
    foldmethod: Option<string, string>
    foldminlines: Option<number, number>
    foldnestmax: Option<number, number>
    foldopen: Option<{string}, string>
    foldtext: Option<string, string>
    formatexpr: Option<string, string>
    formatlistpat: Option<string, string>
    formatoptions: Option<{string: boolean}, string>
    formatprg: Option<string, string>
    fp: Option<string, string>
    fs: Option<boolean, boolean>
    fsync: Option<boolean, boolean>
    ft: Option<string, string>
    gcr: Option<{string}, string>
    gd: Option<boolean, boolean>
    gdefault: Option<boolean, boolean>
    gfm: Option<{string}, string>
    gfn: Option<{string}, string>
    gfw: Option<{string}, string>
    go: Option<{string: boolean}, string>
    gp: Option<string, string>
    grepformat: Option<{string}, string>
    grepprg: Option<string, string>
    gtl: Option<string, string>
    gtt: Option<string, string>
    guicursor: Option<{string}, string>
    guifont: Option<{string}, string>
    guifontwide: Option<{string}, string>
    guioptions: Option<{string: boolean}, string>
    guitablabel: Option<string, string>
    guitabtooltip: Option<string, string>
    helpfile: Option<string, string>
    helpheight: Option<number, number>
    helplang: Option<{string}, string>
    hf: Option<string, string>
    hh: Option<number, number>
    hi: Option<number, number>
    hid: Option<boolean, boolean>
    hidden: Option<boolean, boolean>
    highlight: Option<{string}, string>
    history: Option<number, number>
    hk: Option<boolean, boolean>
    hkmap: Option<boolean, boolean>
    hkmapp: Option<boolean, boolean>
    hkp: Option<boolean, boolean>
    hl: Option<{string}, string>
    hlg: Option<{string}, string>
    hls: Option<boolean, boolean>
    hlsearch: Option<boolean, boolean>
    ic: Option<boolean, boolean>
    icm: Option<string, string>
    icon: Option<boolean, boolean>
    iconstring: Option<string, string>
    ignorecase: Option<boolean, boolean>
    im: Option<boolean, boolean>
    imc: Option<boolean, boolean>
    imcmdline: Option<boolean, boolean>
    imd: Option<boolean, boolean>
    imdisable: Option<boolean, boolean>
    imi: Option<number, number>
    iminsert: Option<number, number>
    ims: Option<number, number>
    imsearch: Option<number, number>
    inc: Option<string, string>
    inccommand: Option<string, string>
    include: Option<string, string>
    includeexpr: Option<string, string>
    incsearch: Option<boolean, boolean>
    inde: Option<string, string>
    indentexpr: Option<string, string>
    indentkeys: Option<{string}, string>
    indk: Option<{string}, string>
    inex: Option<string, string>
    inf: Option<boolean, boolean>
    infercase: Option<boolean, boolean>
    insertmode: Option<boolean, boolean>
    is: Option<boolean, boolean>
    isf: Option<{string}, string>
    isfname: Option<{string}, string>
    isi: Option<{string}, string>
    isident: Option<{string}, string>
    isk: Option<{string}, string>
    iskeyword: Option<{string}, string>
    isp: Option<{string}, string>
    isprint: Option<{string}, string>
    joinspaces: Option<boolean, boolean>
    jop: Option<{string}, string>
    js: Option<boolean, boolean>
    jumpoptions: Option<{string}, string>
    keymap: Option<string, string>
    keymodel: Option<{string}, string>
    keywordprg: Option<string, string>
    km: Option<{string}, string>
    kmp: Option<string, string>
    kp: Option<string, string>
    langmap: Option<{string}, string>
    langmenu: Option<string, string>
    langnoremap: Option<boolean, boolean>
    langremap: Option<boolean, boolean>
    laststatus: Option<number, number>
    lazyredraw: Option<boolean, boolean>
    lbr: Option<boolean, boolean>
    lcs: Option<{string}, string>
    linebreak: Option<boolean, boolean>
    lines: Option<number, number>
    linespace: Option<number, number>
    lisp: Option<boolean, boolean>
    lispoptions: Option<{string}, string>
    lispwords: Option<{string}, string>
    list: Option<boolean, boolean>
    listchars: Option<{string}, string>
    lm: Option<string, string>
    lmap: Option<{string}, string>
    lnr: Option<boolean, boolean>
    loadplugins: Option<boolean, boolean>
    lop: Option<{string}, string>
    lpl: Option<boolean, boolean>
    lrm: Option<boolean, boolean>
    ls: Option<number, number>
    lsp: Option<number, number>
    lw: Option<{string}, string>
    lz: Option<boolean, boolean>
    ma: Option<boolean, boolean>
    magic: Option<boolean, boolean>
    makeef: Option<string, string>
    makeencoding: Option<string, string>
    makeprg: Option<string, string>
    mat: Option<number, number>
    matchpairs: Option<{string}, string>
    matchtime: Option<number, number>
    maxcombine: Option<number, number>
    maxfuncdepth: Option<number, number>
    maxmapdepth: Option<number, number>
    maxmempattern: Option<number, number>
    mco: Option<number, number>
    mef: Option<string, string>
    menc: Option<string, string>
    menuitems: Option<number, number>
    mfd: Option<number, number>
    mh: Option<boolean, boolean>
    mis: Option<number, number>
    mkspellmem: Option<string, string>
    ml: Option<boolean, boolean>
    mle: Option<boolean, boolean>
    mls: Option<number, number>
    mmd: Option<number, number>
    mmp: Option<number, number>
    mod: Option<boolean, boolean>
    modeline: Option<boolean, boolean>
    modelineexpr: Option<boolean, boolean>
    modelines: Option<number, number>
    modifiable: Option<boolean, boolean>
    modified: Option<boolean, boolean>
    more: Option<boolean, boolean>
    mouse: Option<{string: boolean}, string>
    mousef: Option<boolean, boolean>
    mousefocus: Option<boolean, boolean>
    mousehide: Option<boolean, boolean>
    mousem: Option<string, string>
    mousemev: Option<boolean, boolean>
    mousemodel: Option<string, string>
    mousemoveevent: Option<boolean, boolean>
    mouses: Option<{string}, string>
    mousescroll: Option<{string}, string>
    mouseshape: Option<{string}, string>
    mouset: Option<number, number>
    mousetime: Option<number, number>
    mp: Option<string, string>
    mps: Option<{string}, string>
    msm: Option<string, string>
    nf: Option<{string}, string>
    nrformats: Option<{string}, string>
    nu: Option<boolean, boolean>
    number: Option<boolean, boolean>
    numberwidth: Option<number, number>
    nuw: Option<number, number>
    odev: Option<boolean, boolean>
    ofu: Option<string, string>
    omnifunc: Option<string, string>
    opendevice: Option<boolean, boolean>
    operatorfunc: Option<string, string>
    opfunc: Option<string, string>
    pa: Option<{string}, string>
    packpath: Option<{string}, string>
    para: Option<string, string>
    paragraphs: Option<string, string>
    paste: Option<boolean, boolean>
    pastetoggle: Option<string, string>
    patchexpr: Option<string, string>
    patchmode: Option<string, string>
    path: Option<{string}, string>
    pb: Option<number, number>
    pex: Option<string, string>
    ph: Option<number, number>
    pi: Option<boolean, boolean>
    pm: Option<string, string>
    pp: Option<{string}, string>
    preserveindent: Option<boolean, boolean>
    previewheight: Option<number, number>
    previewwindow: Option<boolean, boolean>
    prompt: Option<boolean, boolean>
    pt: Option<string, string>
    pumblend: Option<number, number>
    pumheight: Option<number, number>
    pumwidth: Option<number, number>
    pvh: Option<number, number>
    pvw: Option<boolean, boolean>
    pw: Option<number, number>
    pyx: Option<number, number>
    pyxversion: Option<number, number>
    qe: Option<string, string>
    qftf: Option<string, string>
    quickfixtextfunc: Option<string, string>
    quoteescape: Option<string, string>
    rdb: Option<{string}, string>
    rdt: Option<number, number>
    re: Option<number, number>
    readonly: Option<boolean, boolean>
    redrawdebug: Option<{string}, string>
    redrawtime: Option<number, number>
    regexpengine: Option<number, number>
    relativenumber: Option<boolean, boolean>
    remap: Option<boolean, boolean>
    report: Option<number, number>
    revins: Option<boolean, boolean>
    ri: Option<boolean, boolean>
    rightleft: Option<boolean, boolean>
    rightleftcmd: Option<string, string>
    rl: Option<boolean, boolean>
    rlc: Option<string, string>
    rnu: Option<boolean, boolean>
    ro: Option<boolean, boolean>
    rtp: Option<{string}, string>
    ru: Option<boolean, boolean>
    ruf: Option<string, string>
    ruler: Option<boolean, boolean>
    rulerformat: Option<string, string>
    runtimepath: Option<{string}, string>
    sb: Option<boolean, boolean>
    sbo: Option<{string}, string>
    sbr: Option<string, string>
    sc: Option<boolean, boolean>
    scb: Option<boolean, boolean>
    scbk: Option<number, number>
    scl: Option<string, string>
    scr: Option<number, number>
    scroll: Option<number, number>
    scrollback: Option<number, number>
    scrollbind: Option<boolean, boolean>
    scrolljump: Option<number, number>
    scrolloff: Option<number, number>
    scrollopt: Option<{string}, string>
    scs: Option<boolean, boolean>
    sd: Option<{string}, string>
    sdf: Option<{string}, string>
    sect: Option<string, string>
    sections: Option<string, string>
    secure: Option<boolean, boolean>
    sel: Option<string, string>
    selection: Option<string, string>
    selectmode: Option<{string}, string>
    sessionoptions: Option<{string}, string>
    sft: Option<boolean, boolean>
    sh: Option<string, string>
    shada: Option<{string}, string>
    shadafile: Option<{string}, string>
    shcf: Option<string, string>
    shell: Option<string, string>
    shellcmdflag: Option<string, string>
    shellpipe: Option<string, string>
    shellquote: Option<string, string>
    shellredir: Option<string, string>
    shellslash: Option<boolean, boolean>
    shelltemp: Option<boolean, boolean>
    shellxescape: Option<string, string>
    shellxquote: Option<string, string>
    shiftround: Option<boolean, boolean>
    shiftwidth: Option<number, number>
    shm: Option<{string: boolean}, string>
    shortmess: Option<{string: boolean}, string>
    showbreak: Option<string, string>
    showcmd: Option<boolean, boolean>
    showcmdloc: Option<string, string>
    showfulltag: Option<boolean, boolean>
    showmatch: Option<boolean, boolean>
    showmode: Option<boolean, boolean>
    showtabline: Option<number, number>
    shq: Option<string, string>
    si: Option<boolean, boolean>
    sidescroll: Option<number, number>
    sidescrolloff: Option<number, number>
    signcolumn: Option<string, string>
    siso: Option<number, number>
    sj: Option<number, number>
    slm: Option<{string}, string>
    sloc: Option<string, string>
    sm: Option<boolean, boolean>
    smartcase: Option<boolean, boolean>
    smartindent: Option<boolean, boolean>
    smarttab: Option<boolean, boolean>
    smc: Option<number, number>
    smd: Option<boolean, boolean>
    smoothscroll: Option<boolean, boolean>
    sms: Option<boolean, boolean>
    so: Option<number, number>
    softtabstop: Option<number, number>
    sol: Option<boolean, boolean>
    sp: Option<string, string>
    spc: Option<string, string>
    spell: Option<boolean, boolean>
    spellcapcheck: Option<string, string>
    spellfile: Option<{string}, string>
    spelllang: Option<{string}, string>
    spelloptions: Option<{string}, string>
    spellsuggest: Option<{string}, string>
    spf: Option<{string}, string>
    spk: Option<string, string>
    spl: Option<{string}, string>
    splitbelow: Option<boolean, boolean>
    splitkeep: Option<string, string>
    splitright: Option<boolean, boolean>
    spo: Option<{string}, string>
    spr: Option<boolean, boolean>
    sps: Option<{string}, string>
    sr: Option<boolean, boolean>
    srr: Option<string, string>
    ss: Option<number, number>
    ssl: Option<boolean, boolean>
    ssop: Option<{string}, string>
    sta: Option<boolean, boolean>
    stal: Option<number, number>
    startofline: Option<boolean, boolean>
    statuscolumn: Option<string, string>
    statusline: Option<string, string>
    stc: Option<string, string>
    stl: Option<string, string>
    stmp: Option<boolean, boolean>
    sts: Option<number, number>
    su: Option<{string}, string>
    sua: Option<{string}, string>
    suffixes: Option<{string}, string>
    suffixesadd: Option<{string}, string>
    sw: Option<number, number>
    swapfile: Option<boolean, boolean>
    swb: Option<{string}, string>
    swf: Option<boolean, boolean>
    switchbuf: Option<{string}, string>
    sxe: Option<string, string>
    sxq: Option<string, string>
    syn: Option<string, string>
    synmaxcol: Option<number, number>
    syntax: Option<string, string>
    tabline: Option<string, string>
    tabpagemax: Option<number, number>
    tabstop: Option<number, number>
    tag: Option<{string}, string>
    tagbsearch: Option<boolean, boolean>
    tagcase: Option<string, string>
    tagfunc: Option<string, string>
    taglength: Option<number, number>
    tagrelative: Option<boolean, boolean>
    tags: Option<{string}, string>
    tagstack: Option<boolean, boolean>
    tal: Option<string, string>
    tbidi: Option<boolean, boolean>
    tbs: Option<boolean, boolean>
    tc: Option<string, string>
    tenc: Option<string, string>
    termbidi: Option<boolean, boolean>
    termencoding: Option<string, string>
    termguicolors: Option<boolean, boolean>
    termpastefilter: Option<{string}, string>
    terse: Option<boolean, boolean>
    textwidth: Option<number, number>
    tf: Option<boolean, boolean>
    tfu: Option<string, string>
    tgc: Option<boolean, boolean>
    tgst: Option<boolean, boolean>
    thesaurus: Option<{string}, string>
    thesaurusfunc: Option<string, string>
    tildeop: Option<boolean, boolean>
    timeout: Option<boolean, boolean>
    timeoutlen: Option<number, number>
    title: Option<boolean, boolean>
    titlelen: Option<number, number>
    titleold: Option<string, string>
    titlestring: Option<string, string>
    tl: Option<number, number>
    tm: Option<number, number>
    to: Option<boolean, boolean>
    top: Option<boolean, boolean>
    tpf: Option<{string}, string>
    tpm: Option<number, number>
    tr: Option<boolean, boolean>
    ts: Option<number, number>
    tsr: Option<{string}, string>
    tsrfu: Option<string, string>
    ttimeout: Option<boolean, boolean>
    ttimeoutlen: Option<number, number>
    ttm: Option<number, number>
    ttyfast: Option<boolean, boolean>
    tw: Option<number, number>
    uc: Option<number, number>
    udf: Option<boolean, boolean>
    udir: Option<{string}, string>
    ul: Option<number, number>
    undodir: Option<{string}, string>
    undofile: Option<boolean, boolean>
    undolevels: Option<number, number>
    undoreload: Option<number, number>
    updatecount: Option<number, number>
    updatetime: Option<number, number>
    ur: Option<number, number>
    ut: Option<number, number>
    varsofttabstop: Option<{string}, string>
    vartabstop: Option<{string}, string>
    vb: Option<boolean, boolean>
    vbs: Option<number, number>
    vdir: Option<string, string>
    ve: Option<{string}, string>
    verbose: Option<number, number>
    verbosefile: Option<string, string>
    vfile: Option<string, string>
    vi: Option<string, string>
    viewdir: Option<string, string>
    viewoptions: Option<{string}, string>
    vif: Option<string, string>
    viminfo: Option<string, string>
    viminfofile: Option<string, string>
    virtualedit: Option<{string}, string>
    visualbell: Option<boolean, boolean>
    vop: Option<{string}, string>
    vsts: Option<{string}, string>
    vts: Option<{string}, string>
    wa: Option<boolean, boolean>
    wak: Option<string, string>
    warn: Option<boolean, boolean>
    wb: Option<boolean, boolean>
    wbr: Option<string, string>
    wc: Option<number, number>
    wcm: Option<number, number>
    wd: Option<number, number>
    wfh: Option<boolean, boolean>
    wfw: Option<boolean, boolean>
    wh: Option<number, number>
    whichwrap: Option<{string}, string>
    wi: Option<number, number>
    wic: Option<boolean, boolean>
    wig: Option<{string}, string>
    wildchar: Option<number, number>
    wildcharm: Option<number, number>
    wildignore: Option<{string}, string>
    wildignorecase: Option<boolean, boolean>
    wildmenu: Option<boolean, boolean>
    wildmode: Option<{string}, string>
    wildoptions: Option<{string}, string>
    wim: Option<{string}, string>
    winaltkeys: Option<string, string>
    winbar: Option<string, string>
    winbl: Option<number, number>
    winblend: Option<number, number>
    window: Option<number, number>
    winfixheight: Option<boolean, boolean>
    winfixwidth: Option<boolean, boolean>
    winheight: Option<number, number>
    winhighlight: Option<{string}, string>
    winhl: Option<{string}, string>
    winminheight: Option<number, number>
    winminwidth: Option<number, number>
    winwidth: Option<number, number>
    wiw: Option<number, number>
    wm: Option<number, number>
    wmh: Option<number, number>
    wmnu: Option<boolean, boolean>
    wmw: Option<number, number>
    wop: Option<{string}, string>
    wrap: Option<boolean, boolean>
    wrapmargin: Option<number, number>
    wrapscan: Option<boolean, boolean>
    write: Option<boolean, boolean>
    writeany: Option<boolean, boolean>
    writebackup: Option<boolean, boolean>
    writedelay: Option<number, number>
    ws: Option<boolean, boolean>
    ww: Option<{string}, string>
  end -- }}}

  record GlobalOptionsObjects -- {{{
    acd: Option<boolean, boolean>
    al: Option<number, number>
    aleph: Option<number, number>
    allowrevins: Option<boolean, boolean>
    ambiwidth: Option<string, string>
    ambw: Option<string, string>
    arabicshape: Option<boolean, boolean>
    ari: Option<boolean, boolean>
    arshape: Option<boolean, boolean>
    autochdir: Option<boolean, boolean>
    autowrite: Option<boolean, boolean>
    autowriteall: Option<boolean, boolean>
    aw: Option<boolean, boolean>
    awa: Option<boolean, boolean>
    background: Option<string, string>
    backspace: Option<{string}, string>
    backup: Option<boolean, boolean>
    backupdir: Option<{string}, string>
    backupext: Option<string, string>
    backupskip: Option<{string}, string>
    bdir: Option<{string}, string>
    belloff: Option<{string}, string>
    bex: Option<string, string>
    bg: Option<string, string>
    bk: Option<boolean, boolean>
    bo: Option<{string}, string>
    breakat: Option<{string: boolean}, string>
    brk: Option<{string: boolean}, string>
    browsedir: Option<string, string>
    bs: Option<{string}, string>
    bsdir: Option<string, string>
    bsk: Option<{string}, string>
    casemap: Option<{string}, string>
    cb: Option<{string}, string>
    ccv: Option<string, string>
    cd: Option<{string}, string>
    cdh: Option<boolean, boolean>
    cdhome: Option<boolean, boolean>
    cdpath: Option<{string}, string>
    cedit: Option<string, string>
    cf: Option<boolean, boolean>
    ch: Option<number, number>
    charconvert: Option<string, string>
    clipboard: Option<{string}, string>
    cmdheight: Option<number, number>
    cmdwinheight: Option<number, number>
    cmp: Option<{string}, string>
    co: Option<number, number>
    columns: Option<number, number>
    compatible: Option<boolean, boolean>
    completeopt: Option<{string}, string>
    completeslash: Option<string, string>
    confirm: Option<boolean, boolean>
    cot: Option<{string}, string>
    cp: Option<boolean, boolean>
    cpo: Option<{string: boolean}, string>
    cpoptions: Option<{string: boolean}, string>
    csl: Option<string, string>
    cwh: Option<number, number>
    debug: Option<string, string>
    deco: Option<boolean, boolean>
    delcombine: Option<boolean, boolean>
    dex: Option<string, string>
    dg: Option<boolean, boolean>
    diffexpr: Option<string, string>
    diffopt: Option<{string}, string>
    digraph: Option<boolean, boolean>
    dip: Option<{string}, string>
    dir: Option<{string}, string>
    directory: Option<{string}, string>
    display: Option<{string}, string>
    dy: Option<{string}, string>
    ea: Option<boolean, boolean>
    ead: Option<string, string>
    eadirection: Option<string, string>
    eb: Option<boolean, boolean>
    ed: Option<boolean, boolean>
    edcompatible: Option<boolean, boolean>
    ef: Option<string, string>
    ei: Option<{string}, string>
    emo: Option<boolean, boolean>
    emoji: Option<boolean, boolean>
    enc: Option<string, string>
    encoding: Option<string, string>
    equalalways: Option<boolean, boolean>
    errorbells: Option<boolean, boolean>
    errorfile: Option<string, string>
    eventignore: Option<{string}, string>
    ex: Option<boolean, boolean>
    exrc: Option<boolean, boolean>
    fcl: Option<{string}, string>
    fdls: Option<number, number>
    fdo: Option<{string}, string>
    fencs: Option<{string}, string>
    ffs: Option<{string}, string>
    fic: Option<boolean, boolean>
    fileencodings: Option<{string}, string>
    fileformats: Option<{string}, string>
    fileignorecase: Option<boolean, boolean>
    foldclose: Option<{string}, string>
    foldlevelstart: Option<number, number>
    foldopen: Option<{string}, string>
    fs: Option<boolean, boolean>
    fsync: Option<boolean, boolean>
    gcr: Option<{string}, string>
    gd: Option<boolean, boolean>
    gdefault: Option<boolean, boolean>
    gfm: Option<{string}, string>
    gfn: Option<{string}, string>
    gfw: Option<{string}, string>
    go: Option<{string: boolean}, string>
    grepformat: Option<{string}, string>
    gtl: Option<string, string>
    gtt: Option<string, string>
    guicursor: Option<{string}, string>
    guifont: Option<{string}, string>
    guifontwide: Option<{string}, string>
    guioptions: Option<{string: boolean}, string>
    guitablabel: Option<string, string>
    guitabtooltip: Option<string, string>
    helpfile: Option<string, string>
    helpheight: Option<number, number>
    helplang: Option<{string}, string>
    hf: Option<string, string>
    hh: Option<number, number>
    hi: Option<number, number>
    hid: Option<boolean, boolean>
    hidden: Option<boolean, boolean>
    highlight: Option<{string}, string>
    history: Option<number, number>
    hk: Option<boolean, boolean>
    hkmap: Option<boolean, boolean>
    hkmapp: Option<boolean, boolean>
    hkp: Option<boolean, boolean>
    hl: Option<{string}, string>
    hlg: Option<{string}, string>
    hls: Option<boolean, boolean>
    hlsearch: Option<boolean, boolean>
    ic: Option<boolean, boolean>
    icm: Option<string, string>
    icon: Option<boolean, boolean>
    iconstring: Option<string, string>
    ignorecase: Option<boolean, boolean>
    im: Option<boolean, boolean>
    imc: Option<boolean, boolean>
    imcmdline: Option<boolean, boolean>
    imd: Option<boolean, boolean>
    imdisable: Option<boolean, boolean>
    inccommand: Option<string, string>
    incsearch: Option<boolean, boolean>
    insertmode: Option<boolean, boolean>
    is: Option<boolean, boolean>
    isf: Option<{string}, string>
    isfname: Option<{string}, string>
    isi: Option<{string}, string>
    isident: Option<{string}, string>
    isp: Option<{string}, string>
    isprint: Option<{string}, string>
    joinspaces: Option<boolean, boolean>
    jop: Option<{string}, string>
    js: Option<boolean, boolean>
    jumpoptions: Option<{string}, string>
    keymodel: Option<{string}, string>
    km: Option<{string}, string>
    langmap: Option<{string}, string>
    langmenu: Option<string, string>
    langnoremap: Option<boolean, boolean>
    langremap: Option<boolean, boolean>
    laststatus: Option<number, number>
    lazyredraw: Option<boolean, boolean>
    lines: Option<number, number>
    linespace: Option<number, number>
    lm: Option<string, string>
    lmap: Option<{string}, string>
    lnr: Option<boolean, boolean>
    loadplugins: Option<boolean, boolean>
    lpl: Option<boolean, boolean>
    lrm: Option<boolean, boolean>
    ls: Option<number, number>
    lsp: Option<number, number>
    lz: Option<boolean, boolean>
    magic: Option<boolean, boolean>
    makeef: Option<string, string>
    mat: Option<number, number>
    matchtime: Option<number, number>
    maxcombine: Option<number, number>
    maxfuncdepth: Option<number, number>
    maxmapdepth: Option<number, number>
    maxmempattern: Option<number, number>
    mco: Option<number, number>
    mef: Option<string, string>
    menuitems: Option<number, number>
    mfd: Option<number, number>
    mh: Option<boolean, boolean>
    mis: Option<number, number>
    mkspellmem: Option<string, string>
    mle: Option<boolean, boolean>
    mls: Option<number, number>
    mmd: Option<number, number>
    mmp: Option<number, number>
    modelineexpr: Option<boolean, boolean>
    modelines: Option<number, number>
    more: Option<boolean, boolean>
    mouse: Option<{string: boolean}, string>
    mousef: Option<boolean, boolean>
    mousefocus: Option<boolean, boolean>
    mousehide: Option<boolean, boolean>
    mousem: Option<string, string>
    mousemev: Option<boolean, boolean>
    mousemodel: Option<string, string>
    mousemoveevent: Option<boolean, boolean>
    mouses: Option<{string}, string>
    mousescroll: Option<{string}, string>
    mouseshape: Option<{string}, string>
    mouset: Option<number, number>
    mousetime: Option<number, number>
    msm: Option<string, string>
    odev: Option<boolean, boolean>
    opendevice: Option<boolean, boolean>
    operatorfunc: Option<string, string>
    opfunc: Option<string, string>
    packpath: Option<{string}, string>
    para: Option<string, string>
    paragraphs: Option<string, string>
    paste: Option<boolean, boolean>
    pastetoggle: Option<string, string>
    patchexpr: Option<string, string>
    patchmode: Option<string, string>
    pb: Option<number, number>
    pex: Option<string, string>
    ph: Option<number, number>
    pm: Option<string, string>
    pp: Option<{string}, string>
    previewheight: Option<number, number>
    prompt: Option<boolean, boolean>
    pt: Option<string, string>
    pumblend: Option<number, number>
    pumheight: Option<number, number>
    pumwidth: Option<number, number>
    pvh: Option<number, number>
    pw: Option<number, number>
    pyx: Option<number, number>
    pyxversion: Option<number, number>
    qftf: Option<string, string>
    quickfixtextfunc: Option<string, string>
    rdb: Option<{string}, string>
    rdt: Option<number, number>
    re: Option<number, number>
    redrawdebug: Option<{string}, string>
    redrawtime: Option<number, number>
    regexpengine: Option<number, number>
    remap: Option<boolean, boolean>
    report: Option<number, number>
    revins: Option<boolean, boolean>
    ri: Option<boolean, boolean>
    rtp: Option<{string}, string>
    ru: Option<boolean, boolean>
    ruf: Option<string, string>
    ruler: Option<boolean, boolean>
    rulerformat: Option<string, string>
    runtimepath: Option<{string}, string>
    sb: Option<boolean, boolean>
    sbo: Option<{string}, string>
    sc: Option<boolean, boolean>
    scrolljump: Option<number, number>
    scrollopt: Option<{string}, string>
    scs: Option<boolean, boolean>
    sd: Option<{string}, string>
    sdf: Option<{string}, string>
    sect: Option<string, string>
    sections: Option<string, string>
    secure: Option<boolean, boolean>
    sel: Option<string, string>
    selection: Option<string, string>
    selectmode: Option<{string}, string>
    sessionoptions: Option<{string}, string>
    sft: Option<boolean, boolean>
    sh: Option<string, string>
    shada: Option<{string}, string>
    shadafile: Option<{string}, string>
    shcf: Option<string, string>
    shell: Option<string, string>
    shellcmdflag: Option<string, string>
    shellpipe: Option<string, string>
    shellquote: Option<string, string>
    shellredir: Option<string, string>
    shellslash: Option<boolean, boolean>
    shelltemp: Option<boolean, boolean>
    shellxescape: Option<string, string>
    shellxquote: Option<string, string>
    shiftround: Option<boolean, boolean>
    shm: Option<{string: boolean}, string>
    shortmess: Option<{string: boolean}, string>
    showcmd: Option<boolean, boolean>
    showcmdloc: Option<string, string>
    showfulltag: Option<boolean, boolean>
    showmatch: Option<boolean, boolean>
    showmode: Option<boolean, boolean>
    showtabline: Option<number, number>
    shq: Option<string, string>
    sidescroll: Option<number, number>
    sj: Option<number, number>
    slm: Option<{string}, string>
    sloc: Option<string, string>
    sm: Option<boolean, boolean>
    smartcase: Option<boolean, boolean>
    smarttab: Option<boolean, boolean>
    smd: Option<boolean, boolean>
    sol: Option<boolean, boolean>
    sp: Option<string, string>
    spellsuggest: Option<{string}, string>
    spk: Option<string, string>
    splitbelow: Option<boolean, boolean>
    splitkeep: Option<string, string>
    splitright: Option<boolean, boolean>
    spr: Option<boolean, boolean>
    sps: Option<{string}, string>
    sr: Option<boolean, boolean>
    srr: Option<string, string>
    ss: Option<number, number>
    ssl: Option<boolean, boolean>
    ssop: Option<{string}, string>
    sta: Option<boolean, boolean>
    stal: Option<number, number>
    startofline: Option<boolean, boolean>
    stmp: Option<boolean, boolean>
    su: Option<{string}, string>
    suffixes: Option<{string}, string>
    swb: Option<{string}, string>
    switchbuf: Option<{string}, string>
    sxe: Option<string, string>
    sxq: Option<string, string>
    tabline: Option<string, string>
    tabpagemax: Option<number, number>
    tagbsearch: Option<boolean, boolean>
    taglength: Option<number, number>
    tagrelative: Option<boolean, boolean>
    tagstack: Option<boolean, boolean>
    tal: Option<string, string>
    tbidi: Option<boolean, boolean>
    tbs: Option<boolean, boolean>
    tenc: Option<string, string>
    termbidi: Option<boolean, boolean>
    termencoding: Option<string, string>
    termguicolors: Option<boolean, boolean>
    termpastefilter: Option<{string}, string>
    terse: Option<boolean, boolean>
    tf: Option<boolean, boolean>
    tgc: Option<boolean, boolean>
    tgst: Option<boolean, boolean>
    tildeop: Option<boolean, boolean>
    timeout: Option<boolean, boolean>
    timeoutlen: Option<number, number>
    title: Option<boolean, boolean>
    titlelen: Option<number, number>
    titleold: Option<string, string>
    titlestring: Option<string, string>
    tl: Option<number, number>
    tm: Option<number, number>
    to: Option<boolean, boolean>
    top: Option<boolean, boolean>
    tpf: Option<{string}, string>
    tpm: Option<number, number>
    tr: Option<boolean, boolean>
    ttimeout: Option<boolean, boolean>
    ttimeoutlen: Option<number, number>
    ttm: Option<number, number>
    ttyfast: Option<boolean, boolean>
    uc: Option<number, number>
    udir: Option<{string}, string>
    undodir: Option<{string}, string>
    undoreload: Option<number, number>
    updatecount: Option<number, number>
    updatetime: Option<number, number>
    ur: Option<number, number>
    ut: Option<number, number>
    vb: Option<boolean, boolean>
    vbs: Option<number, number>
    vdir: Option<string, string>
    verbose: Option<number, number>
    verbosefile: Option<string, string>
    vfile: Option<string, string>
    vi: Option<string, string>
    viewdir: Option<string, string>
    viewoptions: Option<{string}, string>
    vif: Option<string, string>
    viminfo: Option<string, string>
    viminfofile: Option<string, string>
    visualbell: Option<boolean, boolean>
    vop: Option<{string}, string>
    wa: Option<boolean, boolean>
    wak: Option<string, string>
    warn: Option<boolean, boolean>
    wb: Option<boolean, boolean>
    wc: Option<number, number>
    wcm: Option<number, number>
    wd: Option<number, number>
    wh: Option<number, number>
    whichwrap: Option<{string}, string>
    wi: Option<number, number>
    wic: Option<boolean, boolean>
    wig: Option<{string}, string>
    wildchar: Option<number, number>
    wildcharm: Option<number, number>
    wildignore: Option<{string}, string>
    wildignorecase: Option<boolean, boolean>
    wildmenu: Option<boolean, boolean>
    wildmode: Option<{string}, string>
    wildoptions: Option<{string}, string>
    wim: Option<{string}, string>
    winaltkeys: Option<string, string>
    window: Option<number, number>
    winheight: Option<number, number>
    winminheight: Option<number, number>
    winminwidth: Option<number, number>
    winwidth: Option<number, number>
    wiw: Option<number, number>
    wmh: Option<number, number>
    wmnu: Option<boolean, boolean>
    wmw: Option<number, number>
    wop: Option<{string}, string>
    wrapscan: Option<boolean, boolean>
    write: Option<boolean, boolean>
    writeany: Option<boolean, boolean>
    writebackup: Option<boolean, boolean>
    writedelay: Option<number, number>
    ws: Option<boolean, boolean>
    ww: Option<{string}, string>
  end -- }}}

  record LocalOptionsObjects -- {{{
    ai: Option<boolean, boolean>
    ar: Option<boolean, boolean>
    arab: Option<boolean, boolean>
    arabic: Option<boolean, boolean>
    autoindent: Option<boolean, boolean>
    autoread: Option<boolean, boolean>
    backupcopy: Option<{string}, string>
    bh: Option<string, string>
    bin: Option<boolean, boolean>
    binary: Option<boolean, boolean>
    bkc: Option<{string}, string>
    bl: Option<boolean, boolean>
    bomb: Option<boolean, boolean>
    breakindent: Option<boolean, boolean>
    breakindentopt: Option<{string}, string>
    bri: Option<boolean, boolean>
    briopt: Option<{string}, string>
    bt: Option<string, string>
    bufhidden: Option<string, string>
    buflisted: Option<boolean, boolean>
    buftype: Option<string, string>
    cc: Option<{string}, string>
    cfu: Option<string, string>
    channel: Option<number, number>
    ci: Option<boolean, boolean>
    cin: Option<boolean, boolean>
    cindent: Option<boolean, boolean>
    cink: Option<{string}, string>
    cinkeys: Option<{string}, string>
    cino: Option<{string}, string>
    cinoptions: Option<{string}, string>
    cinscopedecls: Option<{string}, string>
    cinsd: Option<{string}, string>
    cinw: Option<{string}, string>
    cinwords: Option<{string}, string>
    cms: Option<string, string>
    cocu: Option<string, string>
    cole: Option<number, number>
    colorcolumn: Option<{string}, string>
    com: Option<{string}, string>
    comments: Option<{string}, string>
    commentstring: Option<string, string>
    complete: Option<{string}, string>
    completefunc: Option<string, string>
    concealcursor: Option<string, string>
    conceallevel: Option<number, number>
    copyindent: Option<boolean, boolean>
    cpt: Option<{string}, string>
    crb: Option<boolean, boolean>
    cuc: Option<boolean, boolean>
    cul: Option<boolean, boolean>
    culopt: Option<{string}, string>
    cursorbind: Option<boolean, boolean>
    cursorcolumn: Option<boolean, boolean>
    cursorline: Option<boolean, boolean>
    cursorlineopt: Option<{string}, string>
    def: Option<string, string>
    define: Option<string, string>
    dict: Option<{string}, string>
    dictionary: Option<{string}, string>
    diff: Option<boolean, boolean>
    efm: Option<{string}, string>
    endoffile: Option<boolean, boolean>
    endofline: Option<boolean, boolean>
    eof: Option<boolean, boolean>
    eol: Option<boolean, boolean>
    ep: Option<string, string>
    equalprg: Option<string, string>
    errorformat: Option<{string}, string>
    et: Option<boolean, boolean>
    expandtab: Option<boolean, boolean>
    fcs: Option<{string}, string>
    fdc: Option<string, string>
    fde: Option<string, string>
    fdi: Option<string, string>
    fdl: Option<number, number>
    fdm: Option<string, string>
    fdn: Option<number, number>
    fdt: Option<string, string>
    fen: Option<boolean, boolean>
    fenc: Option<string, string>
    fex: Option<string, string>
    ff: Option<string, string>
    fileencoding: Option<string, string>
    fileformat: Option<string, string>
    filetype: Option<string, string>
    fillchars: Option<{string}, string>
    fixendofline: Option<boolean, boolean>
    fixeol: Option<boolean, boolean>
    flp: Option<string, string>
    fml: Option<number, number>
    fmr: Option<{string}, string>
    fo: Option<{string: boolean}, string>
    foldcolumn: Option<string, string>
    foldenable: Option<boolean, boolean>
    foldexpr: Option<string, string>
    foldignore: Option<string, string>
    foldlevel: Option<number, number>
    foldmarker: Option<{string}, string>
    foldmethod: Option<string, string>
    foldminlines: Option<number, number>
    foldnestmax: Option<number, number>
    foldtext: Option<string, string>
    formatexpr: Option<string, string>
    formatlistpat: Option<string, string>
    formatoptions: Option<{string: boolean}, string>
    formatprg: Option<string, string>
    fp: Option<string, string>
    ft: Option<string, string>
    gp: Option<string, string>
    grepprg: Option<string, string>
    imi: Option<number, number>
    iminsert: Option<number, number>
    ims: Option<number, number>
    imsearch: Option<number, number>
    inc: Option<string, string>
    include: Option<string, string>
    includeexpr: Option<string, string>
    inde: Option<string, string>
    indentexpr: Option<string, string>
    indentkeys: Option<{string}, string>
    indk: Option<{string}, string>
    inex: Option<string, string>
    inf: Option<boolean, boolean>
    infercase: Option<boolean, boolean>
    isk: Option<{string}, string>
    iskeyword: Option<{string}, string>
    keymap: Option<string, string>
    keywordprg: Option<string, string>
    kmp: Option<string, string>
    kp: Option<string, string>
    lbr: Option<boolean, boolean>
    lcs: Option<{string}, string>
    linebreak: Option<boolean, boolean>
    lisp: Option<boolean, boolean>
    lispoptions: Option<{string}, string>
    lispwords: Option<{string}, string>
    list: Option<boolean, boolean>
    listchars: Option<{string}, string>
    lop: Option<{string}, string>
    lw: Option<{string}, string>
    ma: Option<boolean, boolean>
    makeencoding: Option<string, string>
    makeprg: Option<string, string>
    matchpairs: Option<{string}, string>
    menc: Option<string, string>
    ml: Option<boolean, boolean>
    mod: Option<boolean, boolean>
    modeline: Option<boolean, boolean>
    modifiable: Option<boolean, boolean>
    modified: Option<boolean, boolean>
    mp: Option<string, string>
    mps: Option<{string}, string>
    nf: Option<{string}, string>
    nrformats: Option<{string}, string>
    nu: Option<boolean, boolean>
    number: Option<boolean, boolean>
    numberwidth: Option<number, number>
    nuw: Option<number, number>
    ofu: Option<string, string>
    omnifunc: Option<string, string>
    pa: Option<{string}, string>
    path: Option<{string}, string>
    pi: Option<boolean, boolean>
    preserveindent: Option<boolean, boolean>
    previewwindow: Option<boolean, boolean>
    pvw: Option<boolean, boolean>
    qe: Option<string, string>
    quoteescape: Option<string, string>
    readonly: Option<boolean, boolean>
    relativenumber: Option<boolean, boolean>
    rightleft: Option<boolean, boolean>
    rightleftcmd: Option<string, string>
    rl: Option<boolean, boolean>
    rlc: Option<string, string>
    rnu: Option<boolean, boolean>
    ro: Option<boolean, boolean>
    sbr: Option<string, string>
    scb: Option<boolean, boolean>
    scbk: Option<number, number>
    scl: Option<string, string>
    scr: Option<number, number>
    scroll: Option<number, number>
    scrollback: Option<number, number>
    scrollbind: Option<boolean, boolean>
    scrolloff: Option<number, number>
    shiftwidth: Option<number, number>
    showbreak: Option<string, string>
    si: Option<boolean, boolean>
    sidescrolloff: Option<number, number>
    signcolumn: Option<string, string>
    siso: Option<number, number>
    smartindent: Option<boolean, boolean>
    smc: Option<number, number>
    smoothscroll: Option<boolean, boolean>
    sms: Option<boolean, boolean>
    so: Option<number, number>
    softtabstop: Option<number, number>
    spc: Option<string, string>
    spell: Option<boolean, boolean>
    spellcapcheck: Option<string, string>
    spellfile: Option<{string}, string>
    spelllang: Option<{string}, string>
    spelloptions: Option<{string}, string>
    spf: Option<{string}, string>
    spl: Option<{string}, string>
    spo: Option<{string}, string>
    statuscolumn: Option<string, string>
    statusline: Option<string, string>
    stc: Option<string, string>
    stl: Option<string, string>
    sts: Option<number, number>
    sua: Option<{string}, string>
    suffixesadd: Option<{string}, string>
    sw: Option<number, number>
    swapfile: Option<boolean, boolean>
    swf: Option<boolean, boolean>
    syn: Option<string, string>
    synmaxcol: Option<number, number>
    syntax: Option<string, string>
    tabstop: Option<number, number>
    tag: Option<{string}, string>
    tagcase: Option<string, string>
    tagfunc: Option<string, string>
    tags: Option<{string}, string>
    tc: Option<string, string>
    textwidth: Option<number, number>
    tfu: Option<string, string>
    thesaurus: Option<{string}, string>
    thesaurusfunc: Option<string, string>
    ts: Option<number, number>
    tsr: Option<{string}, string>
    tsrfu: Option<string, string>
    tw: Option<number, number>
    udf: Option<boolean, boolean>
    ul: Option<number, number>
    undofile: Option<boolean, boolean>
    undolevels: Option<number, number>
    varsofttabstop: Option<{string}, string>
    vartabstop: Option<{string}, string>
    ve: Option<{string}, string>
    virtualedit: Option<{string}, string>
    vsts: Option<{string}, string>
    vts: Option<{string}, string>
    wbr: Option<string, string>
    wfh: Option<boolean, boolean>
    wfw: Option<boolean, boolean>
    winbar: Option<string, string>
    winbl: Option<number, number>
    winblend: Option<number, number>
    winfixheight: Option<boolean, boolean>
    winfixwidth: Option<boolean, boolean>
    winhighlight: Option<{string}, string>
    winhl: Option<{string}, string>
    wm: Option<number, number>
    wrap: Option<boolean, boolean>
    wrapmargin: Option<number, number>
  end -- }}}

  o: AllOptions
  go: GlobalOptions
  wo: WindowOptions
  bo: BufferOptions
  opt: AllOptionsObjects
  opt_global: GlobalOptionsObjects
  opt_local: LocalOptionsObjects

  record api
    --[[
      API version Information
    
        version: 0.10.0
        compatible: 0
        level: 12
        prerelease: true
    --]]
    
    --[[
      Type mapping (vim -> teal)
      
      Boolean -> boolean
      Buffer -> integer
      Dictionary -> {string:any}
      Float -> number
      Integer -> integer
      Number -> number
      String -> string
      Tabpage -> integer
      Window -> integer
      none of the above -> any
    --]]
    
    nvim_buf_add_highlight: function(integer, integer, string, integer, integer, integer): integer -- (Buffer, Integer, String, Integer, Integer, Integer): Integer
    nvim_buf_attach: function(integer, boolean, {string:any}): boolean -- (Buffer, Boolean, Dictionary): Boolean
    nvim_buf_call: function(integer, any): any -- (Buffer, LuaRef): Object
    nvim_buf_clear_namespace: function(integer, integer, integer, integer) -- (Buffer, Integer, Integer, Integer): void
    nvim_buf_create_user_command: function(integer, string, any, {string:any}) -- (Buffer, String, Object, Dictionary): void
    nvim_buf_del_extmark: function(integer, integer, integer): boolean -- (Buffer, Integer, Integer): Boolean
    nvim_buf_del_keymap: function(integer, string, string) -- (Buffer, String, String): void
    nvim_buf_del_mark: function(integer, string): boolean -- (Buffer, String): Boolean
    nvim_buf_del_user_command: function(integer, string) -- (Buffer, String): void
    nvim_buf_del_var: function(integer, string) -- (Buffer, String): void
    nvim_buf_delete: function(integer, {string:any}) -- (Buffer, Dictionary): void
    nvim_buf_detach: function(integer): boolean -- (Buffer): Boolean
    nvim_buf_get_changedtick: function(integer): integer -- (Buffer): Integer
    nvim_buf_get_commands: function(integer, {string:any}): {string:any} -- (Buffer, Dictionary): Dictionary
    nvim_buf_get_extmark_by_id: function(integer, integer, integer, {string:any}): {integer} -- (Buffer, Integer, Integer, Dictionary): ArrayOf(Integer)
    nvim_buf_get_extmarks: function(integer, integer, any, any, {string:any}): any -- (Buffer, Integer, Object, Object, Dictionary): Array
    nvim_buf_get_keymap: function(integer, string): {{string:any}} -- (Buffer, String): ArrayOf(Dictionary)
    nvim_buf_get_lines: function(integer, integer, integer, boolean): {string} -- (Buffer, Integer, Integer, Boolean): ArrayOf(String)
    nvim_buf_get_mark: function(integer, string): {integer,integer} -- (Buffer, String): ArrayOf(Integer, 2)
    nvim_buf_get_name: function(integer): string -- (Buffer): String
    nvim_buf_get_offset: function(integer, integer): integer -- (Buffer, Integer): Integer
    nvim_buf_get_option: function(integer, string): any -- (Buffer, String): Object
    nvim_buf_get_text: function(integer, integer, integer, integer, integer, {string:any}): {string} -- (Buffer, Integer, Integer, Integer, Integer, Dictionary): ArrayOf(String)
    nvim_buf_get_var: function(integer, string): any -- (Buffer, String): Object
    nvim_buf_is_loaded: function(integer): boolean -- (Buffer): Boolean
    nvim_buf_is_valid: function(integer): boolean -- (Buffer): Boolean
    nvim_buf_line_count: function(integer): integer -- (Buffer): Integer
    nvim_buf_set_extmark: function(integer, integer, integer, integer, {string:any}): integer -- (Buffer, Integer, Integer, Integer, Dictionary): Integer
    nvim_buf_set_keymap: function(integer, string, string, string, {string:any}) -- (Buffer, String, String, String, Dictionary): void
    nvim_buf_set_lines: function(integer, integer, integer, boolean, {string}) -- (Buffer, Integer, Integer, Boolean, ArrayOf(String)): void
    nvim_buf_set_mark: function(integer, string, integer, integer, {string:any}): boolean -- (Buffer, String, Integer, Integer, Dictionary): Boolean
    nvim_buf_set_name: function(integer, string) -- (Buffer, String): void
    nvim_buf_set_option: function(integer, string, any) -- (Buffer, String, Object): void
    nvim_buf_set_text: function(integer, integer, integer, integer, integer, {string}) -- (Buffer, Integer, Integer, Integer, Integer, ArrayOf(String)): void
    nvim_buf_set_var: function(integer, string, any) -- (Buffer, String, Object): void
    nvim_call_atomic: function(any): any -- (Array): Array
    nvim_call_dict_function: function(any, string, any): any -- (Object, String, Array): Object
    nvim_call_function: function(string, any): any -- (String, Array): Object
    nvim_chan_send: function(integer, string) -- (Integer, String): void
    nvim_clear_autocmds: function({string:any}) -- (Dictionary): void
    nvim_cmd: function({string:any}, {string:any}): string -- (Dictionary, Dictionary): String
    nvim_command: function(string) -- (String): void
    nvim_create_augroup: function(string, {string:any}): integer -- (String, Dictionary): Integer
    nvim_create_autocmd: function(any, {string:any}): integer -- (Object, Dictionary): Integer
    nvim_create_buf: function(boolean, boolean): integer -- (Boolean, Boolean): Buffer
    nvim_create_namespace: function(string): integer -- (String): Integer
    nvim_create_user_command: function(string, any, {string:any}) -- (String, Object, Dictionary): void
    nvim_del_augroup_by_id: function(integer) -- (Integer): void
    nvim_del_augroup_by_name: function(string) -- (String): void
    nvim_del_autocmd: function(integer) -- (Integer): void
    nvim_del_current_line: function() -- (): void
    nvim_del_keymap: function(string, string) -- (String, String): void
    nvim_del_mark: function(string): boolean -- (String): Boolean
    nvim_del_user_command: function(string) -- (String): void
    nvim_del_var: function(string) -- (String): void
    nvim_echo: function(any, boolean, {string:any}) -- (Array, Boolean, Dictionary): void
    nvim_err_write: function(string) -- (String): void
    nvim_err_writeln: function(string) -- (String): void
    nvim_eval: function(string): any -- (String): Object
    nvim_eval_statusline: function(string, {string:any}): {string:any} -- (String, Dictionary): Dictionary
    nvim_exec2: function(string, {string:any}): {string:any} -- (String, Dictionary): Dictionary
    nvim_exec_autocmds: function(any, {string:any}) -- (Object, Dictionary): void
    nvim_exec_lua: function(string, any): any -- (String, Array): Object
    nvim_feedkeys: function(string, string, boolean) -- (String, String, Boolean): void
    nvim_get_all_options_info: function(): {string:any} -- (): Dictionary
    nvim_get_api_info: function(): any -- (): Array
    nvim_get_autocmds: function({string:any}): any -- (Dictionary): Array
    nvim_get_chan_info: function(integer): {string:any} -- (Integer): Dictionary
    nvim_get_color_by_name: function(string): integer -- (String): Integer
    nvim_get_color_map: function(): {string:any} -- (): Dictionary
    nvim_get_commands: function({string:any}): {string:any} -- (Dictionary): Dictionary
    nvim_get_context: function({string:any}): {string:any} -- (Dictionary): Dictionary
    nvim_get_current_buf: function(): integer -- (): Buffer
    nvim_get_current_line: function(): string -- (): String
    nvim_get_current_tabpage: function(): integer -- (): Tabpage
    nvim_get_current_win: function(): integer -- (): Window
    nvim_get_hl: function(integer, {string:any}): {string:any} -- (Integer, Dictionary): Dictionary
    nvim_get_hl_id_by_name: function(string): integer -- (String): Integer
    nvim_get_keymap: function(string): {{string:any}} -- (String): ArrayOf(Dictionary)
    nvim_get_mark: function(string, {string:any}): any -- (String, Dictionary): Array
    nvim_get_mode: function(): {string:any} -- (): Dictionary
    nvim_get_namespaces: function(): {string:any} -- (): Dictionary
    nvim_get_option: function(string): any -- (String): Object
    nvim_get_option_info2: function(string, {string:any}): {string:any} -- (String, Dictionary): Dictionary
    nvim_get_option_info: function(string): {string:any} -- (String): Dictionary
    nvim_get_option_value: function(string, {string:any}): any -- (String, Dictionary): Object
    nvim_get_proc: function(integer): any -- (Integer): Object
    nvim_get_proc_children: function(integer): any -- (Integer): Array
    nvim_get_runtime_file: function(string, boolean): {string} -- (String, Boolean): ArrayOf(String)
    nvim_get_var: function(string): any -- (String): Object
    nvim_get_vvar: function(string): any -- (String): Object
    nvim_input: function(string): integer -- (String): Integer
    nvim_input_mouse: function(string, string, string, integer, integer, integer) -- (String, String, String, Integer, Integer, Integer): void
    nvim_list_bufs: function(): {integer} -- (): ArrayOf(Buffer)
    nvim_list_chans: function(): any -- (): Array
    nvim_list_runtime_paths: function(): {string} -- (): ArrayOf(String)
    nvim_list_tabpages: function(): {integer} -- (): ArrayOf(Tabpage)
    nvim_list_uis: function(): any -- (): Array
    nvim_list_wins: function(): {integer} -- (): ArrayOf(Window)
    nvim_load_context: function({string:any}): any -- (Dictionary): Object
    nvim_notify: function(string, integer, {string:any}): any -- (String, Integer, Dictionary): Object
    nvim_open_term: function(integer, {string:any}): integer -- (Buffer, Dictionary): Integer
    nvim_open_win: function(integer, boolean, {string:any}): integer -- (Buffer, Boolean, Dictionary): Window
    nvim_out_write: function(string) -- (String): void
    nvim_parse_cmd: function(string, {string:any}): {string:any} -- (String, Dictionary): Dictionary
    nvim_parse_expression: function(string, string, boolean): {string:any} -- (String, String, Boolean): Dictionary
    nvim_paste: function(string, boolean, integer): boolean -- (String, Boolean, Integer): Boolean
    nvim_put: function({string}, string, boolean, boolean) -- (ArrayOf(String), String, Boolean, Boolean): void
    nvim_replace_termcodes: function(string, boolean, boolean, boolean): string -- (String, Boolean, Boolean, Boolean): String
    nvim_select_popupmenu_item: function(integer, boolean, boolean, {string:any}) -- (Integer, Boolean, Boolean, Dictionary): void
    nvim_set_client_info: function(string, {string:any}, string, {string:any}, {string:any}) -- (String, Dictionary, String, Dictionary, Dictionary): void
    nvim_set_current_buf: function(integer) -- (Buffer): void
    nvim_set_current_dir: function(string) -- (String): void
    nvim_set_current_line: function(string) -- (String): void
    nvim_set_current_tabpage: function(integer) -- (Tabpage): void
    nvim_set_current_win: function(integer) -- (Window): void
    nvim_set_decoration_provider: function(integer, {string:any}) -- (Integer, Dictionary): void
    nvim_set_hl: function(integer, string, {string:any}) -- (Integer, String, Dictionary): void
    nvim_set_hl_ns: function(integer) -- (Integer): void
    nvim_set_hl_ns_fast: function(integer) -- (Integer): void
    nvim_set_keymap: function(string, string, string, {string:any}) -- (String, String, String, Dictionary): void
    nvim_set_option: function(string, any) -- (String, Object): void
    nvim_set_option_value: function(string, any, {string:any}) -- (String, Object, Dictionary): void
    nvim_set_var: function(string, any) -- (String, Object): void
    nvim_set_vvar: function(string, any) -- (String, Object): void
    nvim_strwidth: function(string): integer -- (String): Integer
    nvim_subscribe: function(string) -- (String): void
    nvim_tabpage_del_var: function(integer, string) -- (Tabpage, String): void
    nvim_tabpage_get_number: function(integer): integer -- (Tabpage): Integer
    nvim_tabpage_get_var: function(integer, string): any -- (Tabpage, String): Object
    nvim_tabpage_get_win: function(integer): integer -- (Tabpage): Window
    nvim_tabpage_is_valid: function(integer): boolean -- (Tabpage): Boolean
    nvim_tabpage_list_wins: function(integer): {integer} -- (Tabpage): ArrayOf(Window)
    nvim_tabpage_set_var: function(integer, string, any) -- (Tabpage, String, Object): void
    nvim_ui_attach: function(integer, integer, {string:any}) -- (Integer, Integer, Dictionary): void
    nvim_ui_detach: function() -- (): void
    nvim_ui_pum_set_bounds: function(number, number, number, number) -- (Float, Float, Float, Float): void
    nvim_ui_pum_set_height: function(integer) -- (Integer): void
    nvim_ui_set_focus: function(boolean) -- (Boolean): void
    nvim_ui_set_option: function(string, any) -- (String, Object): void
    nvim_ui_try_resize: function(integer, integer) -- (Integer, Integer): void
    nvim_ui_try_resize_grid: function(integer, integer, integer) -- (Integer, Integer, Integer): void
    nvim_unsubscribe: function(string) -- (String): void
    nvim_win_call: function(integer, any): any -- (Window, LuaRef): Object
    nvim_win_close: function(integer, boolean) -- (Window, Boolean): void
    nvim_win_del_var: function(integer, string) -- (Window, String): void
    nvim_win_get_buf: function(integer): integer -- (Window): Buffer
    nvim_win_get_config: function(integer): {string:any} -- (Window): Dictionary
    nvim_win_get_cursor: function(integer): {integer,integer} -- (Window): ArrayOf(Integer, 2)
    nvim_win_get_height: function(integer): integer -- (Window): Integer
    nvim_win_get_number: function(integer): integer -- (Window): Integer
    nvim_win_get_option: function(integer, string): any -- (Window, String): Object
    nvim_win_get_position: function(integer): {integer,integer} -- (Window): ArrayOf(Integer, 2)
    nvim_win_get_tabpage: function(integer): integer -- (Window): Tabpage
    nvim_win_get_var: function(integer, string): any -- (Window, String): Object
    nvim_win_get_width: function(integer): integer -- (Window): Integer
    nvim_win_hide: function(integer) -- (Window): void
    nvim_win_is_valid: function(integer): boolean -- (Window): Boolean
    nvim_win_set_buf: function(integer, integer) -- (Window, Buffer): void
    nvim_win_set_config: function(integer, {string:any}) -- (Window, Dictionary): void
    nvim_win_set_cursor: function(integer, {integer,integer}) -- (Window, ArrayOf(Integer, 2)): void
    nvim_win_set_height: function(integer, integer) -- (Window, Integer): void
    nvim_win_set_hl_ns: function(integer, integer) -- (Window, Integer): void
    nvim_win_set_option: function(integer, string, any) -- (Window, String, Object): void
    nvim_win_set_var: function(integer, string, any) -- (Window, String, Object): void
    nvim_win_set_width: function(integer, integer) -- (Window, Integer): void
    nvim_win_text_height: function(integer, {string:any}): {string:any} -- (Window, Dictionary): Dictionary
  end

  record json
    record DecodeOpts
      record Luanil
        object: boolean
        array: boolean
      end

      luanil: Luanil
    end

    encode: function(obj: any): string
    decode: function(str: string, opts: DecodeOpts): any
  end

  record ui
    record InputOpts
      prompt: string
      completion: string
      highlight: function()
    end

    input: function(InputOpts, function(string))

    record SelectOpts
      prompt: string
      format_item: function(any): string
      kind: string
    end

    select: function(any, SelectOpts, function(any, integer))
  end

  record iter
    metamethod __call: function<T>(self: iter, src: (function(...: any): T), ...: any): Iter<T>
    metamethod __call: function<T>(self: iter, src: {T}): Iter<T>
    metamethod __call: function<K, V>(self: iter, src: {K: V}): Iter<{K, V}>

    filter: function<T>(f: (function(T): boolean), src: (function(...: any): T), ...: any): {T}
    filter: function<T>(f: (function(T): boolean), src: {T}): {T}
    filter: function<K, V>(f: (function(K, V): boolean), src: {K: V}): {{K, V}}

    map: function<T, U>(f: (function(T): U), src: (function(...: any): T), ...: any): {U}
    map: function<T, U>(f: (function(T): U), src: {T}): {U}
    map: function<K, V, U>(f: (function(K, V): U), src: {K: V}): {U}

    totable: function<T>(f: (function(...: any): T), ...: any): {T}

    record Iter<T>
      metamethod __call: function(self: Iter<T>): T

      all: function(self: Iter<T>, f: function(T): boolean): boolean
      any: function(self: Iter<T>, f: function(T): boolean): boolean
      each: function(self: Iter<T>, f: function(T))
      enumerate: function(self: Iter<T>): Iter<{integer, T}>
      filter: function(self: Iter<T>, f: function(T): boolean): Iter<T>
      find: function(self: Iter<T>, f: T | function(T): boolean): T | nil
      fold: function<U>(self: Iter<T>, init: U, f: function(U, T): U): U
      last: function(self: Iter<T>): T | nil
      map: function<U>(self: Iter<T>, f: function(T): U): Iter<U>
      next: function(self: Iter<T>): T
      nextback: function(self: Iter<T>): T
      nth: function(self: Iter<T>, n: integer): T
      nthback: function(self: Iter<T>, n: integer): T
      peek: function(self: Iter<T>): T
      peekback: function(self: Iter<T>): T
      rev: function(self: Iter<T>): Iter<T>
      rfind: function(self: Iter<T>, f: T | function(T): boolean): T | nil
      skip: function(self: Iter<T>, n: integer): Iter<T>
      skipback: function(self: Iter<T>, n: integer): Iter<T>
      slice: function(self: Iter<T>, first: integer, last: integer): Iter<T>
      totable: function(self: Iter<T>): {T}
    end
  end

  record fs
    record DirOptions
      type SkipFn = function(string): boolean

      depth: integer
      skip: SkipFn
    end

    type FindFn = function(name: string, path: string): boolean

    record FindOptions
      path: string -- Path to begin searching from. If omitted, the |current-directory| is used.
      upward: boolean -- (default: false) If true, search upward through parent directories. Otherwise, search through child directories (recursively).
      stop: string -- Stop searching when this directory is reached. The directory itself is not searched.
      type: string -- Find only files ("file") or directories ("directory"). If omitted, both files and directories that match {names} are included.
      limit: number -- (default: 1) Stop the search after finding this many matches. Use `math.huge` to place no limit on the number of matches.
    end

    record NormalizeOptions
      expand_env: boolean -- (default: true) Expand environment variables
    end

    basename: function(path: string): string | nil
    dir: function(path: string): (function(): string, string)
    dir: function(path: string, opts: DirOptions): (function(): string, string)
    dirname: function(path: string): string | nil
    find: function(names: string | {string} | FindFn): {string}
    find: function(names: string | {string} | FindFn, opts: FindOptions): {string}
    joinpath: function(...: string): string
    normalize: function(path: string): string
    normalize: function(path: string, opts: NormalizeOptions): string
    parents: function(start: string): (function(state: any, previous: string): string)
  end
end

