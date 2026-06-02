import 'dart:convert';
import 'package:ema/contexts/identification/domain/model/queries/get_registered_persons.query.dart';
import 'package:ema/contexts/identification/domain/services/identification.query-service.dart';
import 'package:ema/contexts/identification/interfaces/rest/resources/api_error.resource.dart';
import 'package:ema/contexts/identification/interfaces/rest/resources/registered_persons_page_response.resource.dart';
import 'package:flutter/material.dart';

class RegisteredPersonsListScreen extends StatefulWidget {
  final IdentificationQueryService queryService;

  const RegisteredPersonsListScreen({super.key, required this.queryService});

  @override
  State<RegisteredPersonsListScreen> createState() => _RegisteredPersonsListScreenState();
}

class _RegisteredPersonsListScreenState extends State<RegisteredPersonsListScreen> {
  bool _loading = false;
  String? _error;
  List<RegisteredPersonResource> _items = [];
  int _page = 1;
  final int _pageSize = 20;
  int _total = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
    }
    setState(() {
      _loading = true;
      _error = null;
      if (refresh) {
        _items.clear();
      }
    });

    try {
      final query = GetRegisteredPersonsQuery(page: _page, pageSize: _pageSize);
      final res = await widget.queryService.getRegisteredPersons(query);
      if (mounted) {
        setState(() {
          if (refresh) {
            _items = res.items;
          } else {
            _items.addAll(res.items);
          }
          _total = res.total;
        });
      }
    } on ApiErrorResource catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _loadMore() async {
    if (_loading || _items.length >= _total) return;
    _page++;
    await _loadData(refresh: false);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _loadData(refresh: true),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_error != null) ...[
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(child: Text(_error!)),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () => _loadData(refresh: true),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Expanded(
              child: _items.isEmpty && !_loading
                  ? const Center(
                      child: Text(
                        'No hay usuarios registrados.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _items.length + (_items.length < _total ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _items.length) {
                          // load more trigger
                          _loadMore();
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final item = _items[index];
                        final photoBytes = item.photo != null ? base64Decode(item.photo!) : null;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                  backgroundImage: photoBytes != null ? MemoryImage(photoBytes) : null,
                                  child: photoBytes == null
                                      ? Icon(
                                          Icons.person,
                                          size: 32,
                                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${item.firstName} ${item.lastName}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'DNI: ${item.dni}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (_loading && _items.isEmpty)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
