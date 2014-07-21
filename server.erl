-module(server).
-include("socket.hrl").
-export([start/0]).
-export([data_process/1 , analyze_process/1]).
-define(ANALYZE_PROCESS , analyze_process_pid).
-define(DATA_PROCESS , data_process_pid).

start() ->
	spawn(socket , server_start , [#server_state{port=7777 , accept_state=#accept_state{recv_module=?MODULE , recv_func=data_process , process_reg=?DATA_PROCESS}}]),
	spawn(socket , server_start , [#server_state{port=8888 , accept_state=#accept_state{recv_module=?MODULE , recv_func=analyze_process , process_reg=?ANALYZE_PROCESS}}]).

data_process(Sock) ->
	receive
		{tcp , CSocket , RawMessage} ->
			error_logger:info_msg("[data_process] get [tcp] message : ~p~n" , [RawMessage]),
			?ANALYZE_PROCESS!{message , self() , RawMessage , []},
			data_process(Sock);
		{tcp_closed , CSocket} ->
			error_logger:info_msg("[data_process] tcp closed :~p~n" , [CSocket]);
		{message , From , Message , State} ->
			data_process(Sock)
	end.

analyze_process(Sock) ->
	receive
		{tcp , CSocket , RawMessage} ->
			error_logger:info_msg("[analyze_process] get [tcp] message : ~p~n" , [RawMessage]),
			analyze_process(Sock);
		{tcp_closed , CSocket} ->
			ok;
		{message , From , Message , State} ->
			error_logger:info_msg("[analyze_process] get [process] message : ~p~n" , [Message]),
			gen_tcp:send(Sock , Message),
			analyze_process(Sock)
	end.
