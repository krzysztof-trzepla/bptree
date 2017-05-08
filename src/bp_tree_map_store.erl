%%%-------------------------------------------------------------------
%%% @author Krzysztof Trzepla
%%% @copyright (C) 2017: Krzysztof Trzepla
%%% This software is released under the MIT license cited in 'LICENSE.md'.
%%% @end
%%%-------------------------------------------------------------------
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(bp_tree_map_store).
-author("Krzysztof Trzepla").

-behaviour(bp_tree_store).

%% bp_tree_store callbacks
-export([init/1, terminate/1]).
-export([set_root_id/2, get_root_id/1]).
-export([create_node/2, get_node/2, update_node/3, delete_node/2]).

-type state() :: maps:map([{'$root', bp_tree_node:id()} |
                           {'$next_node_id', bp_tree_node:id()} |
                           {bp_tree_node:id(), bp_tree:node()}]).

%%====================================================================
%% bp_tree_store callbacks
%%====================================================================

%%--------------------------------------------------------------------
%% @doc
%% @todo write me!
%% @end
%%--------------------------------------------------------------------
-spec init(bp_tree_store:args()) -> state().
init(_Args) ->
    #{'$next_node_id' => 1}.

%%--------------------------------------------------------------------
%% @doc
%% @todo write me!
%% @end
%%--------------------------------------------------------------------
-spec set_root_id(bp_tree_node:id(), state()) ->
    {ok | {error, term()}, state()}.
set_root_id(NodeId, State) ->
    {ok, maps:put('$root', NodeId, State)}.

%%--------------------------------------------------------------------
%% @doc
%% @todo write me!
%% @end
%%--------------------------------------------------------------------
-spec get_root_id(state()) ->
    {{ok, bp_tree_node:id()} | {error, term()}, state()}.
get_root_id(State) ->
    case maps:find('$root', State) of
        {ok, NodeId} -> {{ok, NodeId}, State};
        error -> {{error, not_found}, State}
    end.

%%--------------------------------------------------------------------
%% @doc
%% @todo write me!
%% @end
%%--------------------------------------------------------------------
-spec create_node(bp_tree:tree_node(), state()) ->
    {{ok, bp_tree_node:id()} | {error, term()}, state()}.
create_node(Node, State) ->
    NodeId = maps:get('$next_node_id', State),
    State2 = maps:put('$next_node_id', NodeId + 1, State),
    {{ok, NodeId}, maps:put(NodeId, Node, State2)}.

%%--------------------------------------------------------------------
%% @doc
%% @todo write me!
%% @end
%%--------------------------------------------------------------------
-spec get_node(bp_tree_node:id(), state()) ->
    {{ok, bp_tree:tree_node()} | {error, term()}, state()}.
get_node(NodeId, State) ->
    case maps:find(NodeId, State) of
        {ok, Node} -> {{ok, Node}, State};
        error -> {{error, not_found}, State}
    end.

%%--------------------------------------------------------------------
%% @doc
%% @todo write me!
%% @end
%%--------------------------------------------------------------------
-spec update_node(bp_tree_node:id(), bp_tree:tree_node(), state()) ->
    {ok | {error, term()}, state()}.
update_node(NodeId, Node, State) ->
    case maps:find(NodeId, State) of
        {ok, _} -> {ok, maps:put(NodeId, Node, State)};
        error -> {{error, not_found}, State}
    end.

%%--------------------------------------------------------------------
%% @doc
%% @todo write me!
%% @end
%%--------------------------------------------------------------------
-spec delete_node(bp_tree_node:id(), state()) ->
    {ok | {error, term()}, state()}.
delete_node(NodeId, State) ->
    case maps:find(NodeId, State) of
        {ok, _} -> {ok, maps:remove(NodeId, State)};
        error -> {{error, not_found}, State}
    end.

%%--------------------------------------------------------------------
%% @doc
%% @todo write me!
%% @end
%%--------------------------------------------------------------------
-spec terminate(state()) -> ok.
terminate(_State) ->
    ok.
