import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bwa_flutix/models/models.dart';
import 'package:bwa_flutix/services/services.dart';
import 'package:equatable/equatable.dart';

part 'ticket_event.dart';
part 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  TicketBloc() : super(TicketState([])) {
    on<BuyTicket>(_onBuyTicket);
    on<GetTickets>(_onGetTickets);
  }

  Future<void> _onBuyTicket(BuyTicket event, Emitter<TicketState> emit) async {
    await TicketServices.saveTicket(event.userID, event.ticket);

    List<Ticket> updatedTickets = List.from(state.tickets)..add(event.ticket);
    emit(TicketState(updatedTickets));
  }

  Future<void> _onGetTickets(
      GetTickets event, Emitter<TicketState> emit) async {
    List<Ticket> tickets = await TicketServices.getTickets(event.userID);
    emit(TicketState(tickets));
  }
}
