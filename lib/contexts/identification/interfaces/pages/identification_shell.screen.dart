import 'package:dio/dio.dart';
import 'package:ema/contexts/identification/application/internal/commandservices/identification_command_service_impl.dart';
import 'package:ema/contexts/identification/application/internal/queryservices/identification_query_service_impl.dart';
import 'package:ema/contexts/identification/domain/model/valueobjects/api_base_url.valueobject.dart';
import 'package:ema/contexts/identification/infrastructure/api/gateways/identification.http-gateway.dart';
import 'package:ema/contexts/identification/interfaces/pages/identify.screen.dart';
import 'package:ema/contexts/identification/interfaces/pages/register.screen.dart';
import 'package:ema/contexts/identification/interfaces/pages/registered_persons_list.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class IdentificationShellScreen extends StatefulWidget {
  const IdentificationShellScreen({super.key});

  @override
  State<IdentificationShellScreen> createState() => _IdentificationShellScreenState();
}

class _IdentificationShellScreenState extends State<IdentificationShellScreen> {
  int _tabIndex = 0;
  late final _IdentificationServices _services;
  late final String _apiBaseUrl;

  @override
  void initState() {
    super.initState();
    final fallback = 'http://10.0.2.2:8080'; // Standard Android Emulator localhost fallback
    String baseUrl = fallback;
    try {
      if (dotenv.isInitialized) {
        baseUrl = (dotenv.env['API_BASE_URL'] ?? '').trim();
      }
    } catch (_) {
      baseUrl = fallback;
    }
    if (baseUrl.isEmpty) {
      baseUrl = fallback;
    }
    _apiBaseUrl = baseUrl;
    _services = _buildServices(_apiBaseUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reconocimiento Facial - EMA'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: IndexedStack(
        index: _tabIndex,
        children: [
          IdentifyScreen(queryService: _services.queryService),
          RegisterScreen(commandService: _services.commandService),
          RegisteredPersonsListScreen(queryService: _services.queryService),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (i) => setState(() => _tabIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Identificar'),
          BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Registrar'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Usuarios'),
        ],
      ),
    );
  }

  _IdentificationServices _buildServices(String rawBaseUrl) {
    final baseUrl = ApiBaseUrlValueObject(rawBaseUrl).value.toString();
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 40),
        sendTimeout: const Duration(seconds: 40),
      ),
    );

    final gateway = IdentificationHttpGateway(dio);
    return _IdentificationServices(
      commandService: IdentificationCommandServiceImpl(gateway),
      queryService: IdentificationQueryServiceImpl(gateway),
    );
  }
}

class _IdentificationServices {
  final IdentificationCommandServiceImpl commandService;
  final IdentificationQueryServiceImpl queryService;

  _IdentificationServices({required this.commandService, required this.queryService});
}
