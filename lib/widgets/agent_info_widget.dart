import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/app_constants.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';

class AgentInfoWidget extends StatefulWidget {
  final String agentId;

  const AgentInfoWidget({required this.agentId, super.key});

  @override
  _AgentInfoWidgetState createState() => _AgentInfoWidgetState();
}

class _AgentInfoWidgetState extends State<AgentInfoWidget> {
  late Future<Map<String, dynamic>?> _agentDetails;

  @override
  void initState() {
    super.initState();
    _agentDetails = fetchAgentDetails(widget.agentId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _agentDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Text('No agent details available');
        }

        final agent = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: Dimensions.height50,
                      width: Dimensions.width50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(agent['logo'] ?? ''),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                      ),
                    ),
                    SizedBox(width: Dimensions.width10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          agent['name'] ?? 'Agent Name',
                          style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          agent['business_name'] ?? 'Business Name',
                          style: TextStyle(
                              fontSize: Dimensions.font14,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  'View Profile',
                  style: TextStyle(
                      color: AppColors.accentColor,
                      fontSize: Dimensions.font17,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),
            _buildContactButtons(),
          ],
        );
      },
    );
    
    
  }

  Future<Map<String, dynamic>?> fetchAgentDetails(String agentId) async {
    try {
      final response = await Supabase.instance.client
          .from('agents')
          .select('*')
          .eq('id', agentId)
          .single();

      return response;
    } catch (e) {
      debugPrint('Error fetching agent details: $e');
      return null;
    }
  }


  Widget _buildContactButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildContactButton(
            AppConstants.getPngAsset('mail'), 'AGENT', AppColors.blackColor),
        _buildContactButton(
            AppConstants.getPngAsset('whatsapp'), 'AGENT', AppColors.white,
            gradient: AppColors.mainGradient),
      ],
    );
  }

  Widget _buildContactButton(String iconPath, String label, Color textColor,
      {Gradient? gradient}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
      alignment: Alignment.center,
      height: Dimensions.height10 * 5.5,
      width: Dimensions.width20 * 7,
      decoration: BoxDecoration(
          gradient: gradient,
          border: gradient == null
              ? Border.all(
              color: AppColors.blackColor,
              width: Dimensions.width5 / Dimensions.width10)
              : null,
          borderRadius: BorderRadius.circular(Dimensions.radius30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: Dimensions.height24,
            width: Dimensions.width24,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(iconPath),
              ),
            ),
          ),
          Text(
            label,
            style: TextStyle(
                color: textColor,
                fontSize: Dimensions.font17,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
  
}