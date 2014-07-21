-module(socket).
-include("socket.hrl").
-export([server_start/1 , server_start/0 , server_start/2 , client_start/1]).

server_start() ->
	Port=8088,
	server_start(#server_state{port=Port}).

server_start(port , Port) ->
	server_start(#server_state{port=Port}).

server_start(#server_state{port=Port , opt=Opt , accept_state=AState}=State) ->
	case gen_tcp:listen(Port , Opt) of
		{ok , Socket} ->
			log("ok : ~p~n" , [Socket]),
			accept_process(AState#accept_state{socket=Socket}),
			ok;
		{error , Reason} ->
			log("error : ~p~n" , Reason),
			error
	end,
	ok.

client_start(_) ->
	ok.

accept_process(#accept_state{socket=Socket , recv_module=Module , recv_func=Func, process_reg=ProcessReg}=State) ->
	case gen_tcp:accept(Socket) of
		{ok , CSock} ->
			RecvPid = spawn(Module , Func , [CSock]),
			register(ProcessReg , RecvPid),
			gen_tcp:controlling_process(CSock , RecvPid),
			done;
		{error , Reason} ->
			log("error : ~p~n" , [Reason])
	end,
accept_process(State).


log(Content) ->
	error_logger:info_msg(Content , []).
log(Content , Format)->
	error_logger:info_msg(Content , Format).
